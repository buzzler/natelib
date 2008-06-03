package natelib
{
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import mx.utils.StringUtil;
	import mx.collections.XMLListCollection;
	
	public class SessionParser
	{
		private var stream_buffer:String
		private var socket:Socket;
		
		private var session:Session;
		private var data:DataStorage;
		private var session_data:SessionDataStorage;
		
		public function SessionParser(socket:Socket, session:Session):void
		{
			stream_buffer = "";
			this.socket = socket;
			this.session = session;
			this.data = session.data;
			this.session_data = session.session_data;
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
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
				dispatch(line);
				stream_buffer = stream_buffer.substring(i);
			}
		}
		
		private function dispatch(line:String):void
		{
			trace("DISPATCH_STRING@SessionParser:\t\t"+StringUtil.trim(line));
			var params:Array = StringUtil.trim(line).split(Constants._B);
			switch (params[0])
			{
			case Constants.COMMAND_ENTR:
				exeENTR();
				break;
			case Constants.COMMAND_USER:
				exeUSER(params[4], params[5], params[6]);
				break;
			case Constants.COMMAND_JOIN:
				exeJOIN(params[2], params[3], params[4]);
				break;
			case Constants.COMMAND_MESG:
				if (params.length == 5)
					exeMESG(params[2], params[3], params[4]);
				else if (session.short_message != null)
					session.disconnect();
				break;
			case Constants.COMMAND_QUIT:
				exeQUIT(params[2]);
				break;
			}
		}
		
		private function exeENTR():void
		{
			session.dispatchNateEvent(new NateEvent(NateEvent.SESSION_OPEN));
		}
		
		private function exeUSER(email:String, nick:String, name:String):void
		{
			var result:XML;
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					result = x;
					break;
				}
			}
			if (result == null)
			{
				result = Constants.XML_BUDDY.copy();
				result.@FL = 0;
				result.@AL = 0;
				result.@BL = 0;
				result.@RL = 0;
				result.@email = email;
				result.@nick = Codec.decode(nick);
				result.@name = Codec.decode(name);
			}
			session_data.attendance.push(result);
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_UPDATE);
			ne.value = [result.@email, result.@nick];
			session.dispatchNateEvent(ne);
		}
		
		private function exeJOIN(email:String, nick:String, name:String):void
		{
			var result:XML;
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
				{
					result = x;
					break;
				}
			}
			if (result == null)
			{
				result = Constants.XML_BUDDY.copy();
				result.@FL = 0;
				result.@AL = 0;
				result.@BL = 0;
				result.@RL = 0;
				result.@email = email;
				result.@nick = Codec.decode(nick);
				result.@name = Codec.decode(name);
			}
			session_data.attendance.push(result);
/* 			if (session.short_message != null)
			{
				session.sendMessage(session.short_message);
			} */
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_JOIN);
			ne.value = [result.@email, result.@nick];
			session.dispatchNateEvent(ne);
		}
		
		private function exeMESG(email:String, type:String, body:String):void
		{
			var ne:NateEvent;
			switch (type)
			{
			case Constants.COMMAND_TYPING:
				ne = new NateEvent(NateEvent.SESSION_TYPING);
				ne.value = [email, body];
				break;
			case Constants.COMMAND_MSG:
				var bdy:Array = body.split(Constants._D);
				ne = new NateEvent(NateEvent.SESSION_MESSAGE);
				if (bdy.length == 4)
					ne.value = [email, bdy[0], bdy[1], bdy[2], Codec.decode(bdy[3])];
				else if (bdy.length == 1)
					ne.value = [email, Codec.decode(bdy[0])];
				else if (session.short_message != null)
					session.disconnect();
				break;
			}
			if (ne != null)
			{
				session.dispatchNateEvent(ne);
			}
		}
		
		private function exeQUIT(email:String):void
		{
			var i:int;
			var nick:String;
			var x:XML;
			for each(x in session_data.attendance)
			{
				if (x.@email.toString() == email)
				{
					nick = x.@nick.toString();
					session_data.attendance.splice(session_data.attendance.indexOf(x),1);
					break;
				}
			}
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_QUIT);
			ne.value = [email, nick];
			session.dispatchNateEvent(ne);
		}
	}
}