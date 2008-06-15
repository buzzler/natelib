package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class AccountConnector extends Connector
	{
		public	var account	:Account;
		private	var reader	:AccountReader;
		private var writer	:AccountWriter;

		public	function AccountConnector(a:Account)
		{
			super();
			constructor(a);
			listener();
		}
		
		private function constructor(a:Account):void
		{
			account = a;
			reader	= new AccountReader();
			writer	= new AccountWriter();
		}
		
		private function listener():void
		{
			socket.addEventListener(Event.CONNECT,	onOpen);
			socket.addEventListener(Event.CLOSE,	onClose);
		}
		
		private function onOpen(event:Event):void
		{
			socket.addEventListener(ProgressEvent.SOCKET_DATA,			reader.onData);
			account.radio.addEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
		}
		
		private function onClose(event:Event):void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,		reader.onData);
			account.radio.removeEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
		}
	}
}

