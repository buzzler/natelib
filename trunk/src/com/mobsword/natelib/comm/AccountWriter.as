package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.Radio;
	import com.mobsword.natelib.events.RadioEvent;
	import flash.net.Socket;
	/**
	* ...
	* @author Default
	*/
	public class AccountWriter
	{
		private	var socket	:Socket;
		private var radio	:Radio;
		private	var rid		:int;
		
		public	function AccountWriter(s:Socket, r:Radio):void
		{
			socket	= s;
			radio	= r;
			rid		= 0;
		}
		
		public	function onData(event:RadioEvent):void
		{
			var m:Message = event.data as Message;
			m.rid = rid++;

			socket.writeMultiByte(m.toString());
			socket.flush();
		}
	}
	
}