package natelib
{
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.errors.IOError;
	
	public class Client extends EventDispatcher
	{
		/*
		*	variables
		*/
		private var player:Account;
		private var socket:Socket;
		private var trm:TransactionManager;
		private var parser:Parser;
		
		/*
		* Account info
		*/
		public	var	data:DataStorage;
		
		/*
		* system variables
		*/
		private var flag_redirect:Boolean;
		private var buffer:Array;
		
		public function Client(a:Account):void
		{
			player = a;
			data = a.data;
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onClose);
			trm = new TransactionManager(socket);
			parser = new Parser(socket, this, trm);
			flag_redirect = false;
		}

		public function authentication():void
		{
			var service:String = data.email.substring(data.email.indexOf('@')+1, data.email.indexOf('.')).toUpperCase();
			var service_id:String = data.email;
//			if ((service == "NATE")||(service == "LYCOS"))
			if (service == "NATE")
				service_id = data.email.substring(0, data.email.indexOf("@"));
			var key:String = data.pwd + service_id;
			key = Authentication.MD5(key);
			trm.beginTr(new NateEvent(NateEvent.AUTHENTICATION));
				trm.send([Constants.COMMAND_LSIN, data.email, key, "MD5", Constants.NATE_VER, "UTF8"]);
			trm.endTr();
		}
		
		public function getting_details_step1():void
		{
			data.removeList();
			trm.beginTr(new NateEvent(NateEvent.GETTING_DETAIL));
				//trm.send([Constants.COMMAND_CONF, 276, 0]);
				trm.send([Constants.COMMAND_LIST]);
			trm.endTr();
		}
		
		public function getting_details_step2():void
		{
			trm.beginTr(new NateEvent(NateEvent.GETTING_DETAIL));
				trm.send([Constants.COMMAND_GLST, 0]);
			trm.endTr();
		}
		
		public function account_state(s:String):void
		{
			trm.beginTr(new NateEvent(NateEvent.ACCOUNT_STATE));
				trm.send([Constants.COMMAND_ONST, s, 0]);
			trm.endTr();
		}
		
		public function account_rename(s:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.ACCOUNT_UPDATE);
			ne.value = [s];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_CNIK, Codec.encode(s)]);
			trm.endTr();
		}
		
		public function buddy_add(email:String, gid:String, msg:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.BUDDY_UPDATE);
			ne.value = [email, gid];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_ADSB, "REQST", "%00", Codec.encode(email), gid, Codec.encode(msg)]);
			trm.endTr();
		}
		
		public function buddy_remove(gid:String, email:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.BUDDY_UPDATE);
			ne.value = [email, Constants.LIST_FL];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_RMVB, Constants.LIST_FL, gid, email, 0]);
			trm.endTr();
			ne.value = [email, Constants.LIST_BL];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_ADDB, Constants.LIST_BL, gid, email]);
			trm.endTr();
		}
		
		public function buddy_block(id:String, email:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.BUDDY_UPDATE);
			ne.value = [email, Constants.LIST_BL];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_ADDB, Constants.LIST_BL, id, email]);
			trm.endTr();
		}
		
		public function buddy_unblock(id:String, email:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.BUDDY_UPDATE);
			ne.value = [email, Constants.LIST_AL];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_ADDB, Constants.LIST_AL, id, email]);
			trm.endTr();
		}
		
		public function group_add(name:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.GROUP_UPDATE);
			ne.value = [name];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_ADDG, data.serial, Codec.encode(name)]);
			trm.endTr();
		}
		
		public function group_rename(id:String, name:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.GROUP_UPDATE);
			ne.value = [name];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_RENG, data.serial, id, Codec.encode(name)]);
			trm.endTr();
		}
		
		public function group_remove(id:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.GROUP_UPDATE);
			ne.value = [id];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_RMVG, data.serial, id]);
			trm.endTr();
		}
		
		public function pong():void
		{
			trm.send([Constants.COMMAND_PING]);
		}
		
		public function requestLS():void
		{
			trm.send([Constants.COMMAND_PVER, Constants.NATE_VER, "3.0"]);
			trm.send([Constants.COMMAND_AUTH, "DES"]);
			trm.beginTr(new NateEvent(NateEvent.REDIRECTION));
				trm.send([Constants.COMMAND_REQS, "DES", data.email]);
			trm.endTr();
		}
		
		public function requestSS(email:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_REQUEST);
			ne.value = [email];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_RESS]);
			trm.endTr();
		}
		
		public function inviteSS(email:String, ip:String, port:int, key:String):void
		{
			for each(var x:XML in this.data.buddies)
			{
				if ((x.@email == email)&&(x.@status == Constants.STATE_OFFLINE))
					return;
			}
			trm.send([Constants.COMMAND_CTOC, email, "N"], [Constants.COMMAND_INVT, data.email, ip, port.toString(), key]);
		}
		
		public function shortMessage(email:String, msg:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_SHORT_MSG);
			ne.value = [email, msg];
			trm.beginTr(ne);
				trm.send([Constants.COMMAND_RESS]);
			trm.endTr();
		}
		
		public function disconnect():void
		{
			try
			{
				socket.close();
			}
			catch (error:IOError)
			{
				trace("IOError");
			}
		}
		
		public function connect(ip:String, port:int):void
		{
			try
			{
				socket.connect(ip, port);
			}
			catch (error:IOError)
			{
				trace("IOError");
			}
			catch (error:SecurityError)
			{
				trace("SecurityError");
			}
		}
		
		public function redirection(ip:String, port:int):void
		{
			this.flag_redirect = true;
			connect(ip, port);
		}
		
		private function onConnect(event:Event):void
		{
			dispatchEvent(new Event(Event.CONNECT));
			if (!flag_redirect)
				requestLS();
			else
			{
				authentication();
				flag_redirect = false;
			}
		}
		
		private function onClose(event:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
 		public function dispatchNateEvent(event:NateEvent):void
		{
			var ne:NateEvent = new NateEvent(event.type);
			ne.value = event.value;
			dispatchEvent(ne);
		}
	}
}