package natelib
{
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	import flash.errors.IOError;
	import flash.events.Event;

	public class Session extends EventDispatcher
	{
		/*
		* datas
		*/
		public var data:DataStorage;
		public	var session_data:SessionDataStorage;
		
		/*
		* system variables
		*/
		private var player:Account;
		private var socket:Socket;
		private var parser:SessionParser;
		private var sender:SessionSender;
		public	var short_message:String;
		
		public function Session(account:Account):void
		{
			player = account;
			data = account.data;
			session_data = new SessionDataStorage();
			socket = new Socket();
			parser = new SessionParser(socket, this);
			sender = new SessionSender(socket);
			
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onClose);
		}
		
		public function isOnline():Boolean
		{
			return this.socket.connected;
		}
		
		public function connect(ip:String, port:int, key:String, callTo:String, ringFrom:String):void
		{
			session_data.ip = ip;
			session_data.port = port;
			session_data.key = key;
			session_data.callTo = callTo;
			session_data.ringFrom = ringFrom;
			
			try
			{
				socket.connect(ip, port);
			}
			catch (error:IOError)
			{
				trace("IOERROR@Session");
			}
			catch (error:SecurityError)
			{
				trace("SECURITYERROR@Session");
			}
		}
		
		public function invite(email:String):void
		{
			this.player.invitation(email, this);
		}
		
		private function onConnect(event:Event):void
		{
			sender.send([Constants.COMMAND_ENTR, data.email, Codec.encode(data.nick), Codec.encode(data.name), session_data.key, "UTF8", "P"]);
			if (session_data.callTo != null)
				invite(session_data.callTo);
		}
		
		private function onClose(event:Event):void
		{
			trace("ONCLOSE@Session");
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function sendMessage(message:String, font:String = "굴림", font_color:String = "0", font_type:String = ""):void
		{
			var body:String = font+Constants._D+font_color+Constants._D+font_type+Constants._D+Codec.encode(message);
			sender.send([Constants.COMMAND_MESG, Constants.COMMAND_MSG, body]);
		}
		
		public function sendTyping(type:String):void
		{
			sender.send([Constants.COMMAND_MESG, data.email, Constants.COMMAND_TYPING, type]);
		}
		
		public function disconnect():void
		{
			if (!socket.connected)
				return;
			try
			{
				sender.send([Constants.COMMAND_QUIT]);
				socket.close();
			}
			catch (error:IOError)
			{
				trace("IOERROR@Session");
			}
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function dispatchNateEvent(event:NateEvent):void
		{
			if (((event.type == NateEvent.SESSION_JOIN)||(event.type == NateEvent.SESSION_UPDATE))&&(this.short_message != null))
			{
				sendMessage(this.short_message);
//				short_message = null;
			}
			else
				dispatchEvent(event);
		}
	}
}