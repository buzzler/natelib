package msnlib
{
	import flash.events.Event;

	public class AccountEvent extends Event
	{
		public static var FAIL:String = "fail";
		public static var LOGIN:String = "login";
		public static var LOGOUT:String = "logout";
		public static var RENAME:String = "rename";
		public static var GROUP:String = "group";
		public static var BUDDY:String = "buddy";
		public static var STATUS:String = "status";
		public static var BUDDY_ADD:String = "buddy_add";
		public static var BUDDY_DEL:String = "buddy_del";
		public static var BUDDY_STATUS:String = "buddy_status";
		public static var BUDDY_BLCOK:String = "block";
		public static var BUDDY_UNBLCOK:String = "unblock";
		public static var GROUP_ADD:String = "group_add";
		public static var GROUP_DEL:String = "group_del";
		
		public var value:Object;
		
		public function AccountEvent(event:String):void
		{
			super(event);
		}
	}
}