package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.Radio;
	import com.mobsword.natelib.events.RadioEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
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
			trace(buffer);
			if (buffer.length < 1)
				return;
			if (buffer.indexOf('\r\n') < 0)
				return;
			var cmd:String;
			while (buffer.length > 0)
			{
				cmd = buffer.substr(0, 4);
				switch(cmd)
				{
				case Command.CTOC:
				case Command.INVT:
				case Command.MVBG:
				case Command.GWBP:
					onPayload();
					break;
				default:
					if (buffer.lastIndexOf('\r\n') < (buffer.length - 2))
						return;
					onMessage();
					break;
				}
			}
		}

		private function getMessage():Message
		{
			var ary:Array = buffer.substr(0, buffer.indexOf('\r\n')).split(' ');
			var m:Message = new Message();
			if (ary.length > 0)
				m.command	= ary[0] as String;
			if (ary.length > 1)
				m.rid		= parseInt(ary[1] as String);
			if (ary.length > 2)
				m.param		= ary.slice(2);
			return m;
		}
		
		private function flushMessage(length:int = 0):void
		{
			var i:int = buffer.indexOf('\r\n') + 2;
			buffer = buffer.substr(i);
			buffer = buffer.substr(length);
		}

		private function onMessage():void
		{
			var m:Message	= getMessage();
			m.isText		= true;
			radio.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage();
		}
		
		private function onPayload():void
		{
			var m:Message	= getMessage();
			var start:int	= buffer.indexOf('\r\n') + 2;
			var length:int	= parseInt(m.param[m.param.length - 1] as String);
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(buffer.substr(start));
			bytes.position = 0;
			if (bytes.length < length)
				return;
			
			m.data			= bytes.readUTFBytes(length);
			m.isBinary		= true;
			radio.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage(m.data.length);
		}
	}
}

