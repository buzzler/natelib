package natelib
{
	import mx.utils.StringUtil;
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Parser extends EventDispatcher
	{
		/*
		* viriables
		*/
		private	var	socket:Socket;
		private var client:Client;
		private	var trm:TransactionManager;
		
		/*
		* Account info
		*/
		public var data:DataStorage;
		
		/*
		* system variables
		*/
		private var stream_buffer:String;
		
		private var flush_ready:Boolean;
		private var INFY_buffer:Array;

		public function Parser(s:Socket, c:Client, t:TransactionManager):void
		{
			socket = s;
			client = c;
			trm = t;
			data = c.data;
			stream_buffer = "";
			flush_ready = false;
			INFY_buffer = new Array();
			
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		}
		
		private function flushINFY():void
		{
			if (!flush_ready)
				return;
			var b:XML;
			var g:XML;
			while (INFY_buffer.length > 0)
			{
				for each(b in data.buddies)
				{
					if (b.@email.toString() == INFY_buffer[0][0])
						break;
				}
				for each(g in data.online_groups_FL)
				{
					if (g.@id.toString() == b.@group.toString())
					{
						g.appendChild(b);
						break;
					}
				}
				INFY_buffer.splice(0,1);
			}
		}
		
		private function onData(event:ProgressEvent):void
		{
			stream_buffer += socket.readMultiByte(socket.bytesAvailable, "UTF-8");

			var i:int;
			var line:String;
			
			while(stream_buffer.length > 0)
			{
				i = stream_buffer.indexOf(Constants._RN)+2;
				if (i == 1)
					return;
				line = stream_buffer.substring(0, i);
				if (!dispatch(line))
					stream_buffer = stream_buffer.substring(i);
			}
		}
		
		private function exeCTOC():Boolean
		{
			var i:int = stream_buffer.indexOf(Constants._RN);
			var cmd:Array = stream_buffer.substring(0, i).split(Constants._B);
			var payload:int = parseInt(cmd[cmd.length-1]);
			stream_buffer = stream_buffer.substr(i+2);
			
			var body:Array;
			if (stream_buffer.length < payload)
				return false;
			else if (stream_buffer.length == payload)
			{
				body = stream_buffer.split(Constants._B);;
				stream_buffer = "";
			}
			else
			{
				body = stream_buffer.substr(0, payload).split(Constants._B);;
				stream_buffer = stream_buffer.substring(payload);
			}
			
			trace("DISPATCH_PAYLOAD@Parse:\t\t\t"+cmd.join(Constants._B));
			trace("DISPATCH_PAYLOAD@Parse:\t\t\t"+body.join(Constants._B));
			switch (body[0])
			{
			case Constants.COMMAND_INVT:
				exeINVT(body[1], body[2], parseInt(body[3]), body[4]);
				break;
			}
			return true;
		}
		
		private function dispatch(line:String):Boolean
		{
			trace("DISPATCH_STRING@Parse:\t\t\t"+StringUtil.trim(line));
			var flushed:Boolean = false;
			var params:Array = StringUtil.trim(line).split(Constants._B);
			var oid:int = parseInt(params[1]);
			switch(params[0])
			{
			case Constants.ERROR_WRONG_PWD:
			case Constants.ERROR_WRONG_ID:
				exeEROR(params[0]);
				break;
			case Constants.COMMAND_PVER:
				break;
			case Constants.COMMAND_AUTH:
				break;
			case Constants.COMMAND_REQS:
				exeREQS(params[3], parseInt(params[4]));
				break;
			case Constants.COMMAND_LSIN:
				exeLSIN(params[2], params[3], params[4], params[5], params.slice(6,14), params[15]);
				break;
			case Constants.COMMAND_CONF:
				break;
			case Constants.COMMAND_LIST:
				exeLIST(parseInt(params[2])+1, parseInt(params[3]), params[4], params[5], params[6], params[7], params[8], params[9], params[11], params[12]);
				break;
			case Constants.COMMAND_INFY:
				exeINFY(params[2], params[3]);
				break;
			case Constants.COMMAND_NTFY:
				exeNTFY(params[2], params[3]);
				break;
			case Constants.COMMAND_GLST:
				if (params.length < 4)
					exeGLST1(parseInt(params[2]));
				else
					exeGLST2(parseInt(params[2])+1, parseInt(params[3]), params[4], params[5], params[6]);
				break;
			case Constants.COMMAND_ONST:
				exeONST(params[2]);
				break;
			case Constants.COMMAND_CNIK:
				exeCNIK(trm.getValue(oid));
				break;
			case Constants.COMMAND_NNIK:
				exeNNIK(params[2], params[3]);
				trm.attachValue(params[1], [params[2], params[3]]);
				break;
			case Constants.COMMAND_ADDG:
				exeADDG(parseInt(params[2]), params[3], trm.getValue(oid));
				break;
			case Constants.COMMAND_RENG:
				exeRENG(parseInt(params[2]), params[3], trm.getValue(oid));
				break;
			case Constants.COMMAND_RMVG:
				exeRMVG(parseInt(params[2]), trm.getValue(params[1]));
				break;
			case Constants.COMMAND_ADSB:
				exeADSB(parseInt(params[5]), params[3], params[4], trm.getValue(oid));
				break;
			case Constants.COMMAND_ADDB:
				exeADDB(params[2], trm.getValue(oid));
				break;
			case Constants.COMMAND_NPRF:
				exeNPRF(params[2], params[6], params[9]);
				break;
			case Constants.COMMAND_RMVB:
				exeRMVB(parseInt(params[2]), trm.getValue(oid));
				break;
			case Constants.COMMAND_RESS:
				exeRESS(params[2], parseInt(params[3]), StringUtil.trim(params[4]), trm.getValue(oid));
				break;
			case Constants.COMMAND_PING:
				exePING();
				break;
			case Constants.COMMAND_KILL:
				exeKILL();
				break;
			case Constants.COMMAND_CTOC:
				exeCTOC();
				flushed = true;
				break;
			}
			var e:Event = trm.hasEvent(oid);
			if (e != null)
				client.dispatchNateEvent(e as NateEvent);
			return flushed;
		}
		
		private function exeEROR(code:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.ERROR_SIGNIN);
			switch (code)
			{
			case Constants.ERROR_WRONG_ID:
				ne.value = ['Sign in failed because the sign-in name does noe exist.',data.email, data.pwd];
				break;
			case Constants.ERROR_WRONG_PWD:
				ne.value = ['Sing in failed because the password is incorrect.\nIf you have forgotten your password, visit Nateon web-site.',data.email, data.pwd];
				break;
			}
			client.dispatchNateEvent(ne);
		}
		
		private function exeREQS(ip:String, port:int):void
		{
			client.disconnect();
			client.redirection(ip, port);
		}
		
		private function exeLSIN(id:String, name:String, nick:String, mobile:String, tickets:Array, alt_email:String):void
		{
			data.id = id;
			data.name = Codec.decode(name);
			data.nick = Codec.decode(nick);
			data.mobile = mobile;
			data.tickets = tickets;
			data.alt_email = alt_email;
			client.getting_details_step1();
			if (nick == Constants._N)
				data.nick = data.name;
		}
		
		private function exeLIST(i:int, total:int, s:String, e:String, id:String, name:String, nick:String, m:String, b:String, t:String):void
		{
			var ok:String = "1";
			var xml:XML = Constants.XML_BUDDY.copy();
			(s.charAt(0) == ok) ? xml.@FL = 1 : xml.@FL = 0;
			(s.charAt(1) == ok) ? xml.@AL = 1 : xml.@AL = 0;
			(s.charAt(2) == ok) ? xml.@BL = 1 : xml.@BL = 0;
			(s.charAt(3) == ok) ? xml.@RL = 1 : xml.@RL = 0;
			xml.@email = e;
			xml.@id = id;
			xml.@name = Codec.decode(name);
			(nick != Constants._N)	?	xml.@nick = Codec.decode(nick)	:	xml.@nick = xml.@name;
			(m != Constants._N)		?	xml.@mobile = m					:	xml;
			(b != Constants._N)		?	xml.@birth = b					:	xml;
			(t != Constants._N)		?	xml.@tid = t					:	xml;
			xml.@group = -1;
			xml.@status = Constants.STATE_OFFLINE;
			data.buddies.addItem(xml);
			if (xml.@FL == ok)
				data.FL.addItem(xml);
			if (xml.@RL == ok)
				data.RL.addItem(xml);

			if (i == total)
				client.getting_details_step2();
		}
		
		private function exeINFY(email:String, s:String):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					x.@status = s;
					break;
				}
			}
			this.INFY_buffer.push([email, s]);
			this.flushINFY();
		}
		
		private function exeNTFY(email:String, s:String):void
		{
			var old:String;
			var x:XML;
			var g:XML;
			for each(x in data.buddies)
			{
				if (x.@email == email)
				{
					old = x.@status;
					x.@status = s;
					var ne:NateEvent = new NateEvent(NateEvent.BUDDY_STATE);
					ne.value = [email, s, old];
					client.dispatchNateEvent(ne);
					break;
				}
			}
			if (old == Constants.STATE_OFFLINE)
			{
				for each(g in data.online_groups_FL)
				{
					if (g.@id.toString() == x.@group.toString())
					{
						g.appendChild(x);
						break;
					}
				}
			}
			else if (s == Constants.STATE_OFFLINE)
			{
				for each(g in data.online_groups_FL)
				{
					if (g.@id.toString() == x.@group.toString())
						break;
				}
				var c:XMLList = g.children();
				for (var i:int = 0 ; i < c.length() ; i++)
				{
					if (c[i].@email.toString() == x.@email.toString())
					{
						delete c[i];
						break;
					}
				}
			}
		}
		
		private function exeGLST1(serial:int):void
		{
			data.serial = serial;
		}
		
		private function exeGLST2(i:int, total:int, isGroup:String, id:String, name:String):void
		{
			if (isGroup == 'Y')
			{
				var xml:XML = Constants.XML_GROUP.copy();
				xml.@id = id;
				xml.@name = Codec.decode(name);
				data.groups.addItem(xml);
				data.online_groups_FL.addItem(xml.copy());
			}
			else
			{
				var b:XML;
				var g:XML;
				for each(b in data.buddies)
				{
					if (b.@id == id)
					{
						b.@group = name;
						break;
					}
				}
				
				for each(g in data.groups)
				{
					if (g.@id == name)
					{
						g.appendChild(b);
						break;
					}
				}
			}
			if (i == total)
			{
				this.flush_ready = true;
				this.flushINFY();
				client.account_state(data.status);
				client.dispatchNateEvent(new NateEvent(NateEvent.GETTING_COMPLETE));
			}
		}
		
		private function exeONST(status:String):void
		{
			data.status = status;
		}
		
		private function exeCNIK(value:Array):void
		{
			data.nick = Codec.decode(value[0]);
		}
		
		private function exeNNIK(email:String, nick:String):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					x.@nick = Codec.decode(nick);
					break;;
				}
			}
		}
		
		private function exeADDG(serial:int, gid:String, value:Array):void
		{
/*			
			//online_group_FL 리스트 생기기전
			data.serial = serial;
			var xml:XML = Constants.XML_GROUP.copy();
			xml.@id = gid;
			xml.@name = Codec.decode(value[0]);
			data.groups.addItem(xml);
 */			
 			client.getting_details_step1();
		}
		
		private function exeRENG(serial:int, gid:String, value:Array):void
		{
/* 			
			//online_group_FL 리스트 생기기전
			data.serial = serial;
			var x:XML;
			for each(x in data.groups)
			{
				if (x.@id == gid)
				{
					x.@name = Codec.decode(value[0]);
					break;
				}
			}
 */
 			client.getting_details_step1();
		}
		
		private function exeRMVG(serial:int, value:Array):void
		{
/* 			
			//online_group_FL 리스트 생기기전
			data.serial = serial;
			var x:XML;
			for each(x in data.groups)
			{
				if (x.@id == value[0])
				{
					data.groups.removeItemAt(data.groups.getItemIndex(x));
					break;
				}
			}
 */
 			client.getting_details_step1();
		}
		
		private function exeADSB(serial:int, id:String, name:String, value:Array):void
		{
/* 			
			//online_group_FL 리스트 생기기전
			data.serial = serial;
			var email:String = value[0];
			var xml:XML;
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					xml = x;
					break;
				}
			}
			if (xml == null)
			{
				xml = Constants.XML_BUDDY.copy();
				xml.@AL = 1;
				xml.@BL = 0;
				xml.@RL = 0;
				data.buddies.addItem(xml);
			}
			xml.@FL = 1;
			xml.@email = email;
			xml.@id = id;
			xml.@name = Codec.decode(name);
			xml.@nick = Codec.decode(name);
			xml.@group = value[1];
			xml.@status = Constants.STATE_OFFLINE
			data.FL.addItem(xml);
*/
			client.getting_details_step1();
		}
		
		private function exeADDB(id:String, value:Array):void
		{
			var xml:XML;
			for each(xml in data.buddies)
			{
				if (xml.@email == value[0])
					break;
			}
			var list:String = value[1];
			switch (list)
			{
			case Constants.LIST_AL:
				xml.@AL = 1;
				xml.@BL = 0;
				break;
			case Constants.LIST_BL:
				xml.@AL = 0;
				xml.@BL = 1;
				break;
			}
		}
		
		private function exeNPRF(email:String, t:String, b:int):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					x.@tid = t;
					x.@birth = b;
					return;
				}
			}
		}
		
		private function exeRMVB(serial:int, value:Array):void
		{
/* 			
			//online_group_FL 리스트 생기기전
			data.serial = serial;
			var x:XML;

			for each(x in data.FL)
			{
				if ((x.@email == value[0])&&(Constants.LIST_FL == value[1]))
				{
					x.@FL = 0;
					data.FL.removeItemAt(data.FL.getItemIndex(x));
					break;
				}
			}
*/
			client.getting_details_step1();
		}
		
		private function exeRESS(ip:String, port:int, key:String, value:Array):void
		{
			value.push(ip);
			value.push(port);
			value.push(key);
		}
		
		private function exePING():void
		{
			client.pong();
		}
		
		private function exeKILL():void
		{
			data.status = Constants.STATE_OFFLINE;
			var ne:NateEvent = new NateEvent(NateEvent.KILLED);
			ne.value = ['You have been signed out of your Nateon-account because you signed in at another location.'];
			client.dispatchNateEvent(ne);
		}
		
		private function exeINVT(from:String, ip:String, port:int, key:String):void
		{
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_INVITE);
			ne.value = [from, ip, port, key];
			client.dispatchNateEvent(ne);
		}
	}
}