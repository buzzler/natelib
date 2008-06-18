package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.comm.SessionConnector;
	import com.mobsword.natelib.data.SessionData;
	
	/**
	* 서버로부터 데이타를 받은경우 이벤트가 발생한다.
	*/
	[Event(name = "incomingData", type = "com.mobsword.natelib.events.RadioEvent")]
	/**
	* 서버로 보낼 데이타가 있는 경우 이벤트가 발생한다.
	*/
	[Event(name = "outgoingData", type = "com.mobsword.natelib.events.RadioEvent")]
	public class Session
	{
		public	var data:SessionData;
		public	var conn:SessionConnector;

		public	function Session(sd:SessionData)
		{
			data = sd;
			conn = new SessionConnector(this);
		}

		public	function send():void
		{
			;
		}
		
		public	function broadcast():void
		{
			;
		}
	}
}

