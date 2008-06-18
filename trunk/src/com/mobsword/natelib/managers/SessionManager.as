package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	
	/**
	* ...
	* @author Default
	*/
	public class SessionManager extends Manager
	{
		private var all:Object;
		
		public	function SessionManager(a:Account)
		{
			super(a);
			all = new Object();
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch(event.data.command)
			{
			case Command.RESS:
				onRESS(event.data);
				break;
			case Command.CTOC:
				onCTOC(event.data);
				break;
			}
		}
		
		private function onRESS(m:Message):void
		{
			;
		}
		
		private function onCTOC(m:Message):void
		{
			;
		}
	}
	
}