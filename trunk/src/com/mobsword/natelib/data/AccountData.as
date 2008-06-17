/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.data
{
	public class AccountData
	{
		public	var email	:String;
		public	var password:String;
		private	var _state	:String;
		private	var _nick	:String;
		private	var t_state	:String;
		private	var t_nick	:String;
		public	var name	:String;
		public	var ticket	:String;
		
		public	function update():void
		{
			_state	= t_state;
			_nick	= t_nick;
		}
		
		public	function set state(s:String):void
		{
			t_state = s;
		}
		
		public	function get state():String
		{
			return _state;
		}
		
		public	function tempState():String
		{
			return t_state;
		}
		
		public	function set nick(n:String):void
		{
			t_nick = n;
		}
		
		public	function get nick():String
		{
			return _nick;
		}
	}
	
}
