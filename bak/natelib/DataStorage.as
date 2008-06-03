package natelib
{
	import mx.collections.XMLListCollection;
	
	public class DataStorage
	{
		public var email:String;
		public var pwd:String;
		public var status:String;
		
		public var id:String;
		public var name:String;
		public var nick:String;
		public var mobile:String;
		public var tickets:Array;
		public var alt_email:String;

		public var serial:int;
		public var online_groups_FL:XMLListCollection;
		public var buddies:XMLListCollection;
		public var groups:XMLListCollection;
		public var FL:XMLListCollection;
		public var RL:XMLListCollection;
		
		public function DataStorage():void
		{
			online_groups_FL = new XMLListCollection();
			buddies = new XMLListCollection();
			groups = new XMLListCollection();
			FL = new XMLListCollection();
			RL = new XMLListCollection();
		}
		
		public function removeList():void
		{
			serial = 0;
			online_groups_FL.removeAll();
			buddies.removeAll();
			groups.removeAll();
			FL.removeAll();
			RL.removeAll();
		}
	}
}