package com.mobsword.natelib.managers 
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.events.SmsEvent;
	import com.mobsword.natelib.objects.Account;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SmsManager extends Manager
	{
		
		public function SmsManager(a:Account) 
		{
			super(a);
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.GWBP:
				onGWBP(event.data);
				break;
			}
		}
		
		private function onGWBP(m:Message):void
		{
			var index	:int = m.data.indexOf('\r\n\r\n');
			var header	:Array = m.data.substring(0, index).split('\r\n');
			var body	:Array = m.data.substring(index + 4).split(' ');
			
			var time	:String = body[3] as String;
			var year	:Number = parseInt(time.substr(0,4));
			var month	:Number = parseInt(time.substr(4,2)) - 1;
			var date	:Number = parseInt(time.substr(6,2));
			var hour	:Number = parseInt(time.substr(8,2));
			var minute	:Number = parseInt(time.substr(10,2));
			var second	:Number = parseInt(time.substr(12,2));
			
			var e:SmsEvent = new SmsEvent(SmsEvent.NEW_MESSAGE);
			e.command = header[0] as String;
			e.receiver = body[0] as String;
			e.sender = body[1] as String;
			e.message = unescape(body[2] as String);
			e.date = new Date(year, month, date, hour, minute, second);
			
			/*
			*	dispatch Event for external Interface
			*/
			account.dispatchEvent(e);
		}
	}
	
}