package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
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
		private var machine	:AccountAnsweringMachine;

		public	function AccountConnector(a:Account)
		{
			super();
			constructor(a);
			listener();
		}
		
		private function constructor(a:Account):void
		{
			account = a;
			reader	= new AccountReader(socket, a.radio);
			writer	= new AccountWriter(socket, a.radio);
			machine = new AccountAnsweringMachine(a);
		}
		
		private function listener():void
		{
			account.radio.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
			socket.addEventListener(Event.CONNECT,	onOpen);
			socket.addEventListener(Event.CLOSE,	onClose);
		}
		
		override public function open(host:String, port:int):void
		{
			if (queue.length < 1)
			{
				reserve(account.mm.genPVER());
				reserve(account.mm.genAUTH());
				reserve(account.mm.genREQS());
				machine.reserve(Command.LSIN, account.mm.genLIST());
			}
			super.open(host, port);
		}
		
		private function onOpen(event:Event):void
		{
			socket.addEventListener(ProgressEvent.SOCKET_DATA,			reader.onData);
			account.radio.addEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
			
			//Send reserved data
			for each (var c:Message in queue)
			{
				writer.sendData(c);
			}
			queue.length = 0;
		}
		
		private function onClose(event:Event):void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,		reader.onData);
			account.radio.removeEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
		}
		
		private function onIncoming(event:RadioEvent):void
		{
			switch(event.data.command)
			{
			case Command.PVER:
				break;
			case Command.AUTH:
				break;
			case Command.REQS:
				onREQS(event.data);
				break;
			case Command.PING:
				onPING(event.data);
				break;
			case Command.KILL:
				break;
			}
		}
		
		private	function onREQS(m:Message):void
		{
			close();
			reserve(account.mm.genLSIN());
			var h:String= m.param[1] as String;
			var p:int	= parseInt(m.param[2] as String);
			open(h, p);
		}
		
		private function onPING(m:Message):void
		{
			var m:Message = account.mm.genPING();
			account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
		}
	}
}

