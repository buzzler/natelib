package com.mobsword.natelib.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SmsEvent extends Event
	{
		public	static const NEW_MESSAGE	:String = 'sms_message';
		
		public	var command:String;
		public	var receiver:String;
		public	var sender:String;
		public	var message:String;
		public	var date:Date;
		
		public function SmsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}
	
}