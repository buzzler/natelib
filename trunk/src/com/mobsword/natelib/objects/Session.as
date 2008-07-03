package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.comm.SessionConnector;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.data.SessionData;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.managers.AttendentManager;
	import com.mobsword.natelib.managers.ConversationManager;
	
	import flash.events.EventDispatcher;
	
	[Event(name = "incomingData", 	type = "com.mobsword.natelib.events.RadioEvent")]
	[Event(name = "outgoingData", 	type = "com.mobsword.natelib.events.RadioEvent")]
	[Event(name = "s_openSession", 	type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "s_closeSession", type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "s_joinSession", 	type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "s_quitSession", 	type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "s_userSession", 	type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "m_typing", 		type = "com.mobsword.natelib.events.MessageEvent")]
	[Event(name = "m_messege",		type = "com.mobsword.natelib.events.MessageEvent")]
	[Event(name = "m_sent",			type = "com.mobsword.natelib.events.MessageEvent")]
	public class Session extends EventDispatcher
	{
		public	var account	:Account;
		public	var data	:SessionData;
		public	var conn	:SessionConnector;
		public	var am		:AttendentManager;
		public	var cm		:ConversationManager;
		private var history	:Object;

		public	function Session(a:Account, sd:SessionData)
		{
			account	= a;
			data	= sd;
			conn	= new SessionConnector(this);
			am		= new AttendentManager(this);
			cm		= new ConversationManager(this);
			history = new Object();
		}

		public	function online():void
		{
			conn.open(data.host, data.port);
		}
		
		public	function offline():void
		{
			conn.close();
		}

		public	function send(msg:String, font:String = '굴림', color:String = '0', type:String = ''):void
		{
			var embed:Message = data.account.mm.genMSG(msg, font, color, type);
			var mesg:Message = data.account.mm.genMESG(embed);
			broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mesg), true);
		}
		
		public	function broadcast(event:RadioEvent, record:Boolean = false):void
		{
			dispatchEvent(event);
			if (record)
				history[event.data.rid.toString()] = event;
		}
		
		public	function AOD(id:String, flush:Boolean = true):RadioEvent
		{
			var e:RadioEvent = history[id] as RadioEvent;
			if (flush)
				history[id] = null;
			return e;
		}
	}
}

