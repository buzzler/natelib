package msnlib
{
	import flash.events.Event;

	public class AuthenticationApolloEvent extends Event
	{
		public static var	AUTHORIZE	:String	=	"authorize";
		public static var	UNAUTHORIZE	:String	=	"unauthorize";
		public function AuthenticationApolloEvent(event:String):void
		{
			super(event);
		}
	}
}