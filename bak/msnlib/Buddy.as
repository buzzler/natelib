package msnlib
{
	public class Buddy
	{
		public var user:String;
		public var nick:String;
		public var today:String;
		public var CID:String;
		public var groupIDs:Array;
		public var clientID:uint;
		public var status:String;
		public var isForward:Boolean;
		public var isAllow:Boolean;
		public var isBlock:Boolean;
		public var isReverse:Boolean;
		public var isPending:Boolean;
		
		public function Buddy():void
		{
			groupIDs = new Array();
			status = Account.STATUS_DISAVAILABLE;
		}
		public function setListNumber(num:int):void
		{
			if ((num&1) == 1)
				this.isForward = true;
			else
				this.isForward = false;
			if ((num&2) == 2)
				this.isAllow = true;
			else
				this.isAllow = false;
			if ((num&4) == 4)
				this.isBlock = true;
			else
				this.isBlock = false;
			if ((num&8) == 8)
				this.isReverse = true;
			else
				this.isReverse = false;
			if ((num&16) == 16)
				this.isPending = true;
			else
				this.isPending = false;
		}
	}
}