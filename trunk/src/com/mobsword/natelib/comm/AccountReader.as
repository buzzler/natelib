package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.events.Radio;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	/**
	* ...
	* @author Default
	*/
	public class AccountReader
	{
		private	var socket	:Socket;
		private var radio	:Radio;
		private var buffer	:String;
		
		public	function AccountReader(s:Socket, r:Radio):void
		{
			socket	= s;
			radio	= r;
			buffer	= '';
		}
		
		public	function onData(event:ProgressEvent):void
		{
			buffer += socket.readMultiByte(socket.bytesAvailable, 'UTF-8');
		}
	}
	
}