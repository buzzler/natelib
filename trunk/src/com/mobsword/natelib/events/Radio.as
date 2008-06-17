package com.mobsword.natelib.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	* 서버로부터 데이타를 받은경우 이벤트가 발생한다.
	*/
	[Event(name = "incomingData", type = "com.mobsword.natelib.events.RadioEvent")]
	/**
	* 서버로 보낼 데이타가 있는 경우 이벤트가 발생한다.
	*/
	[Event(name = "outgoingData", type = "com.mobsword.natelib.events.RadioEvent")]
	public class Radio extends EventDispatcher
	{
		public	function Radio(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		public	function broadcast(event:RadioEvent):void
		{
			dispatchEvent(event);
		}
	}
	
}