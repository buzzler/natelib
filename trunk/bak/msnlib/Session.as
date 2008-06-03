package msnlib
{
	public class Session
	{
		public var sid:String;
		public var users:Array;
		public var nicks:Array;
		public function Session():void
		{
			users = new Array();
			nicks = new Array();
		}
	}
}