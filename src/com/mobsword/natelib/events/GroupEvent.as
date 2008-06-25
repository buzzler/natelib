package com.mobsword.natelib.events
{
	import flash.events.Event;

	public class GroupEvent extends Event
	{
		public function GroupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}