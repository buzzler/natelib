package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.objects.Session;
	
	import flash.net.Socket;
	
	public class SessionWriter
	{
		private var socket:Socket;
		private var session:Session;
		
		public function SessionWriter(s:Socket, ss:Session)
		{
			socket = s;
			session = ss;
		}

	}
}