package com.mobsword.natelib.data
{
	import com.mobsword.natelib.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class GroupData
	{
		public	var account	:Account;
		public	var id		:String;
		public	var name	:String;
		public	var friends	:Array;
		
		public function GroupData()
		{
			friends = new Array();
		}
		
	}
	
}