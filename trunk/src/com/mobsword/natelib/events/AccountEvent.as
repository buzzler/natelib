package com.mobsword.natelib.events
{
	import flash.events.Event;

	public class AccountEvent extends Event
	{
		public function AccountEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}