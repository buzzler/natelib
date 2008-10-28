package natelib
{
	import flash.events.Event;

	public class NateEvent extends Event
	{
		/*
		* Constants
		*/
		public static var ERROR_SIGNIN:String		= "error_signin";
		public static var REDIRECTION:String		= "redirection";
		public static var AUTHENTICATION:String		= "authentication";
		public static var GETTING_DETAIL:String		= "getting_detail";
		public static var GETTING_COMPLETE:String	= "getting_complete";
		public static var LOGIN:String				= "login"
		public static var LOGOUT:String				= "logout";
		public static var ACCOUNT_STATE:String		= "account_state";
		public static var BUDDY_STATE:String		= "buddy_state";
		public static var ACCOUNT_UPDATE:String		= "account_update";
		public static var BUDDY_UPDATE:String		= "buddy_update";
		public static var GROUP_UPDATE:String		= "group_update";
		public static var SESSION_REQUEST:String	= "session_request";
		public static var SESSION_INVITE:String		= "session_invite";
		public static var SESSION_OPEN:String		= "session_open";
		public static var SESSION_JOIN:String		= "session_join";
		public static var SESSION_MESSAGE:String	= "session_mesg";
		public static var SESSION_TYPING:String		= "session_type";
		public static var SESSION_CLOSE:String		= "session_close";
		public static var SESSION_UPDATE:String		= "session_update";
		public static var SESSION_SHORT_MSG:String	= "session_short_msg";
		public static var SESSION_QUIT:String		= "session_quit";
		public static var KILLED:String				= "killed";
		/*
		* variables
		*/
		public var value:Array;

		public function NateEvent(type:String):void
		{
			super(type);
			value = new Array();
		}
	}
}