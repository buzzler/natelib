package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.comm.SessionConnector;
	import com.mobsword.natelib.data.SessionData;
	import com.mobsword.natelib.events.RadioEvent;
	
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
		public	var account:Account;
		public	var data:SessionData;
		public	var conn:SessionConnector;

		public	function Session(a:Account, sd:SessionData)
		{
			account	= a;
			data	= sd;
			conn	= new SessionConnector(this);
		}

		public	function online():void
		{
			conn.open(data.host, data.port);
		}
		
		public	function offline():void
		{
			conn.close();
		}

		public	function send():void
		{
			;
		}
		
		public	function broadcast(event:RadioEvent):void
		{
			;
		}
	}
}

