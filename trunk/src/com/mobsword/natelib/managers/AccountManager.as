package com.mobsword.natelib.managers {
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.utils.Codec;
	
	/**
	* ...
	* @author Default
	*/
	public class AccountManager extends Manager
	{
		
		public function AccountManager(a:Account)
		{
			super(a);
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.LSIN:
				onLSIN(event.data);
				break;
			case Command.CONF:
				onCONF(event.data);
				break;
			case Command.ONST:
				onONST(event.data);
				break;
			case Command.CNIK:
				onCNIK(event.data);
				break;
			}
		}
		
		private function onLSIN(m:Message):void
		{
			account.data.name	= Codec.decode(m.param[1] as String);
			account.data.nick	= Codec.decode(m.param[2] as String);
			account.data.ticket	= m.param[5] as String;
		}
		
		private function onCONF(m:Message):void
		{
			;
		}
		
		private function onONST(m:Message):void
		{
			account.data.update();
		}
		
		private function onCNIK(m:Message):void
		{
			account.data.update();
		}
	}
	
}