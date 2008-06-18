package com.mobsword.natelib.comm
{
	import com.mobsword.natelib.objects.Session;
	
	
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
			reader = new SessionReader(socket, ss);
			writer = new SessionWriter(socket, ss);
		}
		
		private function listener():void
		{
			;
		}
	}
	
}