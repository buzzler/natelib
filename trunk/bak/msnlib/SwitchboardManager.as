package msnlib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class SwitchboardManager extends EventDispatcher
	{
		public var buddy_invite:String;
		public var boards:Array;

		public function SwitchboardManager():void
		{
			this.boards = new Array();
		}
		public function openSession(ip:String, port:int):int
		{
			var sb:Switchboard = new Switchboard(ip, port);
			sb.addEventListener(SwitchboardEvent.INITIALROASTER, onInitialRoaster);
			sb.addEventListener(SwitchboardEvent.ANSWER, onAnswer);
			sb.addEventListener(SwitchboardEvent.CALLING, onCalling);
			sb.addEventListener(SwitchboardEvent.DISCONNECT, onDisconnect);
			var idx:int = boards.push(sb) - 1;
			return idx;
		}
		public function enterSession(ip:String, port:int, user:String, auth:String, sid:String):void
		{
			var i:int = openSession(ip, port);
			this.boards[i].enterSession(user, auth, sid);
		}
		public function newSession(ip:String, port:int, user:String, auth:String, buddy:String):void
		{
			var i:int = openSession(ip, port);
			this.boards[i].newSession(user, auth, buddy);
		}
		public function talkSession(sid:String, msg:String):void
		{
			var sb:Switchboard = whichSession(sid);
			sb.talkSession(msg);
		}
		public function outSession(sid:String):void
		{
 			var sb:Switchboard = whichSession(sid);
			if (sb != null)
				sb.finalize();
		}
		public function outAllSession():void
		{
			var i:int;
			for (i = 0 ; i < this.boards.length ; i++)
			{
				(this.boards[i] as Switchboard).quitSession();
			}
			this.boards = new Array();
		}
		public function getSwitchboard(sid:String):Switchboard
		{
			return whichSession(sid);
		}
		public function getRoasterUser(sid:String):Array
		{
			return whichSession(sid).participants_user;
		}
		public function getRoasterNick(sid:String):Array
		{
			return whichSession(sid).participants_nick;
		}
		private function onInitialRoaster(event:SwitchboardEvent):void
		{
 			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.INITIALROASTER);
			sbe.sid = event.target.sid;
			sbe.roaster_nick = event.target.participants_nick;
			sbe.roaster_user = event.target.participants_user;
			dispatchEvent(sbe);
		}
		private function onAnswer(event:SwitchboardEvent):void
		{
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.ANSWER);
			sbe.sid = event.target.sid;
			sbe.roaster_nick = event.target.participants_nick;
			sbe.roaster_user = event.target.participants_user;
			dispatchEvent(sbe);
		}
		private function onCalling(event:SwitchboardEvent):void
		{
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.CALLING);
			sbe.sid = event.sid;
			dispatchEvent(sbe);
		}
		private function onDisconnect(event:SwitchboardEvent):void
		{
			var i:int;
			for (i = 0 ; i < this.boards.length ; i++)
			{
				if ((this.boards[i] as Switchboard).sid == event.sid)
				{
					this.boards.splice(i,1);
					break;
				}
			}
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.DISCONNECT);
			sbe.sid = event.sid;
			dispatchEvent(sbe);
		}
		public function whichSession(sid:String):Switchboard
		{
			if (this.boards == null)
				return null;
			if (this.boards.length == 0)
				return null;
			var result:int;
			var start:int = 0;
			var seek:int;
			var end:int = this.boards.length-1;
			while (true)
			{
				seek = Math.round((start+end) / 2);
				result = sid.localeCompare(this.boards[seek].sid);
				if (result < 0)
				{
					end = seek-1;;
				}
				else if (result == 0)
				{
					return this.boards[seek];
				}
				else if (result > 0)
				{
					start = seek + 1;
				}
				
				if (start > end)
					return null;
			} 
			return null;
		}
	}
}