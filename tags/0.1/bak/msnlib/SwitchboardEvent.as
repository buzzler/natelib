package msnlib
{
	import flash.events.Event;
	import mx.charts.AreaChart;

	public class SwitchboardEvent extends Event
	{
		public static var RINGING		:String = "RNG";
		public static var INITIALROASTER:String = "IRO";
		public static var ANSWER		:String = "ANS";
		public static var NEWSWITCHBOARD:String = "USR";
		public static var CALLING		:String = "CAL";
		public static var JOIN			:String = "JOI";
		public static var MESSAGE		:String = "MSG";
		public static var CONTROL		:String = "x-msmsgscontrol";
		public static var DATA			:String = "x-msmsgsinvite";
		public static var EMOTICON		:String = "x-mms-animemoticon";
		public static var BYE			:String = "BYE";
		public static var DISCONNECT	:String = "disconnect";
		public var sid:String;
		public var roaster_user:Array;
		public var roaster_nick:Array;
		public var message:String;
		public var color:String;
		public var isItalic:Boolean;
		public var isBold:Boolean;
		public var isUnderline:Boolean;
		public function SwitchboardEvent(event:String):void
		{
			super(event);
			this.roaster_user = new Array();
			this.roaster_nick = new Array();
		}
	}
}