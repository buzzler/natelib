package natelib
{
	import flash.events.Event;
	
	
	public class SessionManager
	{
		private var sessions_info:Array;
		private var player:Account;
		
		public function SessionManager(account:Account):void
		{
			sessions_info = new Array();
			player = account;
		}
		
		public function shortSession(ip:String, port:int, key:String, callTo:String, msg:String):Session
		{
			var s:Session = new Session(player);
			s.short_message = msg;
			s.connect(ip, port, key, callTo, null);
			return s;
		}
		
		public function addSession(ip:String, port:int, key:String, callTo:String = null, ringFrom:String = null):Session
		{
			var s:Session = new Session(player);
			s.addEventListener(Event.CLOSE, removeSession);
			s.connect(ip, port, key, callTo, ringFrom);
			this.sessions_info.push(s);
			return s;
		}
		
		private function removeSession(event:Event):void
		{
			var i:int;
			for (i = 0 ; i < sessions_info.length ; i++)
			{
				if (sessions_info[i] as Session == event.target as Session)
					break;
			}
			this.sessions_info.splice(i,1);
		}
		
		public function removeSessionAll():void
		{
			for each(var s:Session in sessions_info)
			{
				s.disconnect();
			}
			this.sessions_info = new Array();
		}
	}
}