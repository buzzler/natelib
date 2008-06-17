package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.FriendData;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.objects.Friend;
	import com.mobsword.natelib.objects.Group;
	
	/**
	* ...
	* @author Default
	*/
	public class FriendManager extends Manager
	{
		public	var numFriends:int;
		public	var all		:Object;
		public	var foward	:Array;
		public	var allow	:Array;
		public	var block	:Array;
		public	var reverse	:Array;
		
		public	function FriendManager(a:Account)
		{
			super(a);
			all		= new Object();
			foward	= new Array();
			allow	= new Array();
			block	= new Array();
			reverse	= new Array();
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch(event.data.command)
			{
			case Command.LIST:
				onLIST(event.data);
				break;
			case Command.INFY:
				onLIST(event.data);
				break;
			case Command.NTFY:
				onNTFY(event.data);
				break;
			case Command.NNIK:
				onNNIK(event.data);
				break;
			case Command.ADSB:
				onADSB(event.data);
				break;
			case Command.ADDB:
				onADDB(event.data);
				break;
			case Command.RMVB:
				onRMVB(event.data);
				break;
			}
		}
		
		public	function add(email:String, group:Group, msg:String):void
		{
			account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genADSB(email, group.data.id, msg)));
		}
		
		public	function getFriendByEmail(email:String):Friend
		{
			return all[email] as Friend;
		}
		
		public	function getFriendById(id:String):Friend
		{
			return all[id] as Friend;
		}
		
		private function onLIST(m:Message):void
		{
			numFriends			= parseInt(m.param[1]);
			var lists:String	= m.param[2] as String;
			var fd:FriendData	= new FriendData();

			fd.index	= parseInt(m.param[0] as String);
			fd.email	= m.param[3] as String;
			fd.id		= m.param[4] as String;
			fd.name		= m.param[5] as String;
			fd.nick		= m.param[6] as String;
			fd.mobile	= m.param[7] as String;
			fd.birth	= m.param[9] as String;
			
			var f:Friend = new Friend(fd);
				all[fd.email] = f;			//all
				all[fd.id] = f;
			if (lists.charAt(0) == '1')
				foward.push(f);				//foward
			if (lists.charAt(1) == '1')
			{
				allow.push(f);				//allow
				fd.block = false;
			}
			if (lists.charAt(2) == '1')
			{
				block.push(f);				//block
				fd.block = true;
			}
			if (lists.charAt(3) == '1')
				reverse.push(f);			//reverse

			if (numFriends == (fd.index+1))
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genGLST()));
		}
		
		private function onINFY(m:Message):void
		{
			var f:Friend = getFriendByEmail(m.param[0] as String);
			f.data.state = m.param[1] as String;
		}
		
		private function onNTFY(m:Message):void
		{
			var f:Friend = getFriendByEmail(m.param[0] as String);
			f.data.state = m.param[1] as String;
		}
		
		private function onNNIK(m:Message):void
		{
			;
		}
		
		private function onADSB(m:Message):void
		{
			;
		}
		
		private function onADDB(m:Message):void
		{
			;
		}
		
		private function onRMVB(m:Message):void
		{
			;
		}
	}
}




