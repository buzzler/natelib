package msnlib
{
	import flash.events.Event;
	
	public class AuthenticationEvent extends Event
	{
		public static var TICKET		:String = "ticket";
		public static var REDIRECTION	:String = "redirection";
		public static var UNAUTHORIZED	:String = "unauthorized";
		
		public function AuthenticationEvent(event:String):void
		{
			super(event);
		}
	}
}