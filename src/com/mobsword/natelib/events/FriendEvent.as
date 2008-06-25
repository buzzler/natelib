package com.mobsword.natelib.events
{
	import flash.events.Event;

	public class FriendEvent extends Event
	{
		public function FriendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}