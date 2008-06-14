package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.data.FriendData;
	import com.mobsword.natelib.objects.Account;
	
	/**
	* ...
	* @author Default
	*/
	public class FriendManager extends Manager
	{
		public	var data:FriendData;
		
		public	function FriendManager(a:Account)
		{
			super(a);
			data = new FriendData();
		}
		
		public	function add():void
		{
			;
		}
	}
}




