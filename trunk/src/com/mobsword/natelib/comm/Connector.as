package com.mobsword.natelib.comm
{
	import flash.errors.IOError;
	import flash.net.Socket;
	
	/**
	* ...
	* @author Default
	*/
	public class Connector
	{
		private	var socket:Socket;

		public	function Connector()
		{
			;
		}

		public	function open(host:String, port:int):void
		{
			try
			{
				socket.connect(host, port);
			}
			catch (e:IOError)
			{
				;
			}
			catch (e:SecurityError)
			{
				;
			}
		}
		
		public	function close():void
		{
			try
			{
				socket.close();
			}
			catch (e:IOError)
			{
				;
			}
		}
	}
}

