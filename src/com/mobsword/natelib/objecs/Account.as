/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.objecs
{
	import com.mobsword.natelib.data.UserData;
	import com.mobsword.natelib.managers.ConnectionManager;
	import com.mobsword.natelib.managers.FriendManager;
	import com.mobsword.natelib.managers.GroupManager;
	import com.mobsword.natelib.managers.SessionManager;
	import flash.events.EventDispatcher;

	public class Account extends EventDispatcher
	{
		public	var data:AccountData;
		public	var cm	:ConnectionManager;
		public	var gm	:GroupManager;
		public	var fm	:FriendManager;
		public	var sm	:SessionManager;

		public	function Account()
		{
			super();
			constructor();
			listener();
		}
		
		private	function constructor():void
		{
			data	= new AccountData();
			cm		= new ConnectionManager();
			gm		= new GroupManager();
			fm		= new FriendManager();
			sm		= new SessionManager();
		}
		
		private function listener():void
		{
			;
		}
		
		public	function online(email:String = null, password:String = null, state:String = null):void
		{
			data.email		= email;
			data.password	= password;
			data.state		= state;
		}
		
		public	function offline():void
		{
			;
		}
		
		public	function busy():void
		{
			;
		}
		
		public	function away():void
		{
			;
		}
		
		public	function phone():void
		{
			;
		}
		
		public	function meet():void
		{
			;
		}
		
		public	function hidden():void
		{
			;
		}
		
		public	function addGroup():void
		{
			;
		}
		
		public	function addFriend():void
		{
			;
		}
	}
	
}
