package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.objects.Session;
	
	import flash.net.Socket;
	
	public class SessionReader
	{
		private var socket:Socket;
		private var session:Session;
		
		public function SessionReader(s:Socket, ss:Session)
		{
			socket = s;
			session = ss;
		}

	}
}