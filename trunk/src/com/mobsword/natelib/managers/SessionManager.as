package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.data.SessionData;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.events.SessionEvent;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.objects.Session;
	
	/**
	* ...
	* @author Default
	*/
	public class SessionManager extends Manager
	{
		private var all:Object;
		
		public	function SessionManager(a:Account)
		{
			super(a);
			all = new Object();
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch(event.data.command)
			{
			case Command.RESS:
				onRESS(event.data);
				break;
			case Command.CTOC:
				onCTOC(event.data);
				break;
			}
		}
		
		private function onRESS(m:Message):void
		{
			var sd:SessionData = new SessionData();
			sd.account	= account;
			sd.host		= m.param[0] as String;
			sd.port		= parseInt(m.param[1] as String);
			sd.id		= m.param[2] as String;
			var s:Session = new Session(account, sd);
			
			all[sd.id]	= s;
			/*
			*	dispatch Event for external Interface
			*/
			var se:SessionEvent = new SessionEvent(SessionEvent.NEW_SESSION);
			se.session = s;
			account.dispatchEvent(se);
		}
		
		private function onCTOC(m:Message):void
		{
			var param:Array = m.data.split(' ');
			var cmd:String	= param[0] as String;
			if (cmd != Command.INVT)
				return;
			var from:String	= param[1] as String;
			var host:String = param[2] as String;
			var port:int	= parseInt(param[3] as String);
			var id:String	= param[4] as String;
			
			var sd:SessionData = new SessionData();
			sd.account		= account;
			sd.host			= host;
			sd.port			= port;
			sd.id			= id;
			var s:Session	= new Session(account, sd);
			
			all[sd.id]		= s;
			/**
			 * dispatch Event for external Interface
			 */
			var se:SessionEvent = new SessionEvent(SessionEvent.INVITE_SESSION);
			se.friend = account.fm.getFriendByEmail(from);
			se.session = s;
			account.dispatchEvent(se);
		}
	}
	
}