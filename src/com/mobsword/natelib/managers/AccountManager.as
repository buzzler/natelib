package com.mobsword.natelib.managers {
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.AccountEvent;
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
			
			var ae:AccountEvent = new AccountEvent(AccountEvent.STATE_CHANGE);
			ae.account = account;
			ae.old_value = account.data.state;
			
			account.data.state = account.radio.AOD(m.rid.toString()).data.param[0] as String;

			/*
			*	dispatch Event for external Interface
			*/
			ae.new_value = account.data.state;
			account.dispatchEvent(ae);
		}
		
		private function onCNIK(m:Message):void
		{
			var ae:AccountEvent = new AccountEvent(AccountEvent.NICK_CHANGE);
			ae.account = account;
			ae.old_value = account.data.nick;
			
			account.data.nick = Codec.decode(account.radio.AOD(m.rid.toString()).data.param[0] as String);

			/*
			*	dispatch Event for external Interface
			*/
			ae.new_value = account.data.nick;
			account.dispatchEvent(ae);
		}
	}
	
}