package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.managers.Manager;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.events.RadioEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class SessionManager extends Manager
	{
		
		public function SessionManager(a:Account)
		{
			super(a);
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch(event.data.command)
			{
			case Command.RESS:
				break;
			case Command.CTOC:
				break;
			}
		}
	}
	
}