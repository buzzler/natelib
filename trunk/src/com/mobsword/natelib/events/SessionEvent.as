package com.mobsword.natelib.events
{
	import flash.events.Event;

	public class SessionEvent extends Event
	{
		public	static const OUTGOING_DATA	:String = 'outgoingData';
		public	static const INCOMING_DATA	:String = 'incomingData';
		
		public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}