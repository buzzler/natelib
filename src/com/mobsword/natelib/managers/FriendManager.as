package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.constants.ListType;
	import com.mobsword.natelib.data.FriendData;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.FriendEvent;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.objects.Friend;
	import com.mobsword.natelib.objects.Group;
	import com.mobsword.natelib.utils.Codec;
	
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
			case Command.NPRF:
				onNPRF(event.data);
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
			case Command.MVBG:
				onMVBG(event.data);
				break;
			}
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

			fd.account	= account;
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
			var fe:FriendEvent = new FriendEvent(FriendEvent.STATE_CHANGE);
			fe.friend = f;
			fe.old_value = f.data.state;
			f.data.state = m.param[1] as String;
			fe.new_value = f.data.state;
			
			/*
			*	dispatch Event for external Interface
			*/
			account.dispatchEvent(fe);
			f.dispatchEvent(fe);
		}
		
		private function onNNIK(m:Message):void
		{
			var f:Friend = getFriendByEmail(m.param[0] as String);
			var fe:FriendEvent = new FriendEvent(FriendEvent.NICK_CHANGE);
			fe.friend = f;
			fe.old_value = f.data.nick;
			f.data.nick	= Codec.encode(m.param[1] as String);
			fe.new_value = f.data.nick;
			
			/*
			*	dispatch Event for external Interface
			*/
			account.dispatchEvent(fe);
			f.dispatchEvent(fe);
		}
		
		private function onNPRF(m:Message):void
		{
			var f:Friend = getFriendByEmail(m.param[0] as String);
		}
		
		private function onADSB(m:Message):void
		{
			var fd:FriendData = new FriendData();
			fd.account	= account;
			fd.email	= account.radio.AOD(m.rid.toString()).data.param[2] as String;
			fd.id		= m.param[2] as String;
			fd.name		= m.param[3] as String;
			var f:Friend= new Friend(fd);
			all[fd.email]=f;
			all[fd.id]	= f;
			foward.push(f);
			allow.push(f);
			
			/*
			*	dispatch Event for external Interface
			*/
			var fe:FriendEvent = new FriendEvent(FriendEvent.NEW_FRIEND);
			fe.friend = f;
			account.dispatchEvent(fe);
		}
		
		private function onADDB(m:Message):void
		{
			var list	:String;
			var friend	:Friend;
			var param	:Array;
			if (m.rid > 0)
			{
				param = account.radio.AOD(m.rid.toString()).data.param;
				
				list	= param[0] as String;
				friend	= getFriendByEmail(param[1] as String);
			}
			else
			{
				param = m.param;
				
				list	= param[0] as String;
				friend	= getFriendByEmail(param[2] as String);
			}
			
			switch (list)
			{
			case ListType.ALLOWED:
				allow.push(friend);
				break;
			case ListType.BLOCKED:
				block.push(friend);
				break;
			case ListType.FOWARD:
				foward.push(friend);
				break;
			case ListType.REVERSE:
				reverse.push(friend);
				break;
			}
			
			/*
			*	dispatch Event for external Interface
			*/
			var fe:FriendEvent = new FriendEvent(FriendEvent.LIST_CHANGE);
			fe.friend = friend;
			account.dispatchEvent(fe);
			friend.dispatchEvent(fe);
		}
		
		private function onRMVB(m:Message):void
		{
			var i		:int;
			var list	:String;
			var friend	:Friend;
			var param:Array;
			if (m.rid > 0)
			{
				param = account.radio.AOD(m.rid.toString()).data.param;
				
				list	= param[0] as String;
				friend	= getFriendByEmail(param[1] as String);

			}
			else
			{
				param = m.param;
				list	= param[0] as String;
				friend	= getFriendByEmail(param[2] as String);
			}
			
			switch (list)
			{
			case ListType.ALLOWED:
				i = allow.indexOf(friend);
				allow.splice(i,1);
				break;
			case ListType.BLOCKED:
				i = allow.indexOf(friend);
				block.splice(i,1);
				break;
			case ListType.FOWARD:
				i = foward.indexOf(friend);
				foward.splice(i,1);
				break;
			case ListType.REVERSE:
				i = reverse.indexOf(friend);
				reverse.splice(i,1);
				break;
			}
			
			/*
			*	dispatch Event for external Interface
			*/
			var fe:FriendEvent = new FriendEvent(FriendEvent.LIST_CHANGE);
			fe.friend = friend;
			account.dispatchEvent(fe);
			friend.dispatchEvent(fe);
		}
		
		private function onMVBG(m:Message):void
		{
			var temp:String = account.radio.AOD(m.rid.toString()).data.data.substr(0, parseInt(m.param[1] as String));
			var param:Array = temp.split(' ');
			var f:Friend = account.fm.getFriendById(param[1] as String);
			var fg:Group = account.gm.getGroupById(param[3] as String);
			var tg:Group = account.gm.getGroupById(param[4] as String);
			account.gm.version = m.param[0] as String;
			f.data.group = tg;
			tg.data.friends.push(f);
			fg.data.friends.splice(fg.data.friends.indexOf(f),1);
			
			/*
			*	dispatch Event for external Interface
			*/
			var fe:FriendEvent = new FriendEvent(FriendEvent.GROUP_CHANGE);
			fe.friend = f;
			fe.old_group = fg;
			fe.new_group = tg;
			account.dispatchEvent(fe);
			f.dispatchEvent(fe);
		}
	}
}




