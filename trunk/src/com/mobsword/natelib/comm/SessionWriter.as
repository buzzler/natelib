package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Session;
	
	import flash.net.Socket;
	
	public class SessionWriter
	{
		private var socket:Socket;
		private var session:Session;
		private	var rid:int;
		
		public function SessionWriter(s:Socket, ss:Session)
		{
			socket = s;
			session = ss;
			rid = 0;
		}

		public	function onData(event:RadioEvent):void
		{
			var m:Message = event.data as Message;
			sendData(m);
		}

		public	function sendData(m:Message):void
		{
			m.rid = rid++;
			socket.writeMultiByte(m.toString(), 'UTF-8');
			socket.flush();
		}
	}
}