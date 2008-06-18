package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.GroupData;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.objects.Group;
	import com.mobsword.natelib.utils.Codec;
	
	/**
	* ...
	* @author Default
	*/
	public class GroupManager extends Manager
	{
		public	var version		:String;
		public	var all			:Object;
		public	var numGroups	:int;
		private var numPackets	:int;

		public	function GroupManager(a:Account)
		{
			super(a);
			version = '';
			all = new Object();
			numGroups = 0;
			numPackets = 0;
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.GLST:
				onGLST(event.data);
				break;
			case Command.ADDG:
				onADDG(event.data);
				break;
			case Command.RENG:
				onRENG(event.data);
				break;
			case Command.RMVG:
				onRMVG(event.data);
				break;
			}
		}
		
		public	function getGroupById(id:String):Group
		{
			return all[id] as Group;
		}
		
		private function onGLST(m:Message):void
		{
			if (m.param.length < 4)
			{
				version = m.param[0] as String;
				return;
			}
			var current:int	= parseInt(m.param[0] as String);
			numPackets = parseInt(m.param[1] as String);
			var g:Group;
			var isGroup:String = m.param[2] as String;
			switch (isGroup)
			{
			case 'Y':
				var gd:GroupData = new GroupData();
				gd.account	= account;
				gd.id		= m.param[3] as String;
				gd.name		= Codec.decode(m.param[4] as String);
				g			= new Group(gd);
				all[gd.id]	= g;
				numGroups++;
				break;
			case 'N':
				var f:Friend	= account.fm.getFriendById(m.param[3] as String);
				g				= getGroupById(m.param[4] as String);
				g.data.friends.push(f);
				f.data.group	= g;
				break;
			}
			
			if (numPackets == (current+1))
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genONST(account.data.t_state)), true);
		}
		
		private function onADDG(m:Message):void
		{
			var param:Array = account.radio.AOD(m.rid.toString()).data.param;
			var gd:GroupData = new GroupData();
			version		= m.param[0] as String;
			gd.account	= account;
			gd.id		= m.param[1] as String;
			gd.name		= Codec.decode(param[1] as String);
			var g:Group = new Group(gd);
			all[gd.id]	= g;
			numGroups++;
		}
		
		private function onRENG(m:Message):void
		{
			var param:Array = account.radio.AOD(m.rid.toString()).data.param;
			var g:Group = getGroupById(param[1] as String);
			g.data.name = param[2] as String;
		}
		
		private function onRMVG(m:Message):void
		{
			var param:Array = account.radio.AOD(m.rid.toString()).data.param;
			var g:Group		= getGroupById(param[1] as String);
			all[g.data.id]	= null;
			numGroups--;
		}
	}
	
}