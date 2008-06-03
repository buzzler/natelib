package natelib
{
	import mx.collections.XMLListCollection;
	
	public class SessionDataStorage
	{
		public var ip:String;
		public var port:int;
		public var key:String;
		public var callTo:String;
		public var ringFrom:String;

//		public var attendance:XMLListCollection;
		public var attendance:Array;
		
		public function SessionDataStorage():void
		{
//			attendance = new XMLListCollection();
			attendance = new Array();
		}
	}
}