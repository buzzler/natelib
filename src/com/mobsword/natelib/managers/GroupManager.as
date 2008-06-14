package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.data.GroupData;
	import com.mobsword.natelib.managers.Manager;
	import com.mobsword.natelib.objects.Account;
	
	/**
	* ...
	* @author Default
	*/
	public class GroupManager extends Manager
	{
		public	var data:GroupData;

		public	function GroupManager(a:Account)
		{
			super(a);
			data = new GroupData();
		}
		
		public	function add():void
		{
			;
		}
	}
	
}