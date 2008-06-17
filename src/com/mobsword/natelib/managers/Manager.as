/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;

	public class Manager
	{
		public	var account:Account;

		public	function Manager(a:Account)
		{
			account = a;
			account.radio.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
		}
		
		protected function onIncoming(event:RadioEvent):void
		{
			;
		}
	}
	
}
