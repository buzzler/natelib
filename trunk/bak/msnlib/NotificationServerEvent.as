package msnlib
{
	import flash.events.Event;

	public class NotificationServerEvent extends Event
	{
		public static var MESSAGE_PROFILE	:String	= "profile";
		public static var MESSAGE_INIT_MAIL	:String	= "init_mail";
		public static var MESSAGE_NEW_MAIL	:String	= "new_mail";
		public static var MESSAGE_MAILBOX	:String	= "mailbox";
		public static var MESSAGE_SYSTEM	:String	= "system";
		public static var LOGIN				:String	= "login";
		public static var DISCONNECT		:String = "disconnect";
		public static var UNAUTHORIZED		:String	= "unauthorized";
		public static var BUDDY				:String = "buddy";
		public static var GROUP				:String = "group";
		public static var TODAY				:String = "today";
		public static var STATUS			:String = "status";
		public static var BUDDY_STATUS		:String = "buddy_status";
			public static var RENAME			:String = "rename";
			public static var BUDDY_MOVE		:String = "buddy_move";			//***
			public static var BUDDY_ADD			:String = "buddy_add";			//***
			public static var BUDDY_DEL			:String = "buddy_del";			//***
			public static var BUDDY_BLOCK		:String = "buddy_block";		//***
			public static var BUDDY_UNBLOCK		:String = "buddy_unblock";		//***
			public static var GROUP_ADD			:String = "group_add";
			public static var GROUP_DEL			:String = "group_del";
			public static var GROUP_RENAME		:String = "group_rename";

		public var user:String;
		public var nick:String;
		public var message:Message;
		public var buddy:Array;
		public var group:Array;
		public var today:String;
		public var status:String;
		
		public function NotificationServerEvent(event:String):void
		{
			super(event);
		}
	}
}