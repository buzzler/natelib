package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	
	public class AccountAnsweringMachine
	{
		private var account	:Account;
		private	var hash	:Object;

		public	function AccountAnsweringMachine(a:Account)
		{
			account = a;
			hash	= new Object();
			account.radio.addEventListener(RadioEvent.INCOMING_DATA, onEvent);
		}

		public	function reserve(cmd:String, msg:Message):void
		{
			hash[cmd] = msg;
		}

		private	function onEvent(event:RadioEvent):void
		{
			var m:Message = hash[event.data.command] as Message;
			if (m != null)
			{
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
				hash[event.data.command] = null;
			}
		}
	}
}