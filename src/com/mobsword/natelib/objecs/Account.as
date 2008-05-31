/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.objecs
{
	import com.mobsword.natelib.data.UserData;
	import flash.events.EventDispatcher;

	public class Account extends EventDispatcher
	{
		public	var data:UserData;

		public	function Account()
		{
			super();
			constructor();
			listener();
		}
		
		private	function constructor():void
		{
			data = new UserData();
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
	}
	
}
