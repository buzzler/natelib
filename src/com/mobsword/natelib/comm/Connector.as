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
		protected	var socket:Socket;

		public	function Connector()
		{
			socket = new Socket();
		}

		public	function open(host:String, port:int):void
		{
			try
			{
				socket.connect(host, port);
			}
			catch (e:IOError)
			{
				throw e;
			}
			catch (e:SecurityError)
			{
				throw e;
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
				throw e;
			}
		}
	}
}

