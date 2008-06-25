package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.comm.SessionConnector;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.data.SessionData;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.managers.AttendentManager;
	import com.mobsword.natelib.managers.ConversationManager;
	
	import flash.events.EventDispatcher;
	
	/**
	* 서버로부터 데이타를 받은경우 이벤트가 발생한다.
	*/
	[Event(name = "incomingData", type = "com.mobsword.natelib.events.RadioEvent")]
	/**
	* 서버로 보낼 데이타가 있는 경우 이벤트가 발생한다.
	*/
	[Event(name = "outgoingData", type = "com.mobsword.natelib.events.RadioEvent")]
	public class Session extends EventDispatcher
	{
		public	var account	:Account;
		public	var data	:SessionData;
		public	var conn	:SessionConnector;
		public	var am		:AttendentManager;
		public	var cm		:ConversationManager;

		public	function Session(a:Account, sd:SessionData)
		{
			account	= a;
			data	= sd;
			conn	= new SessionConnector(this);
			am		= new AttendentManager(this);
			cm		= new ConversationManager(this);
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
			broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mesg));
		}
		
		public	function broadcast(event:RadioEvent):void
		{
			dispatchEvent(event);
		}
	}
}

