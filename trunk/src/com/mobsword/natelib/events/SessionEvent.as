package com.mobsword.natelib.events
{
	import flash.events.Event;

	public class SessionEvent extends Event
	{
		public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}