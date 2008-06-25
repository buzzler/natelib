package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Session;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionConnector extends Connector
	{
		private var session:Session;
		private var reader:SessionReader;
		private var writer:SessionWriter;
		
		public function SessionConnector(ss:Session)
		{
			constructor(ss);
			listener();
		}
		
		
		private function constructor(ss:Session):void
		{
			session= ss;
			reader = new SessionReader(socket, ss);
			writer = new SessionWriter(socket, ss);
		}
		
		private function listener():void
		{
			socket.addEventListener(Event.CONNECT,	onOpen);
			socket.addEventListener(Event.CLOSE,	onClose);
		}
		
		override public function open(host:String, port:int):void
		{
			reserve(session.account.mm.genENTR(session.data.id));
			super.open(host, port);
		}
		
		private function onOpen(event:Event):void
		{
			socket.addEventListener(ProgressEvent.SOCKET_DATA, reader.onData);
			session.addEventListener(RadioEvent.OUTGOING_DATA, writer.onData);
			
			//Send reserved data
			for each (var c:Message in queue)
			{
				writer.sendData(c);
			}
			queue.length = 0;
		}
		
		private function onClose(event:Event):void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, reader.onData);
			session.removeEventListener(RadioEvent.OUTGOING_DATA, writer.onData);
		}
	}
	
}