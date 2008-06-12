/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.data
{
	public class Message
	{
		public	var rid		:int;
		public	var command	:String;
		public	var param	:Array;
		public	var isBinary:Boolean;
		public	var isText	:Boolean;

		public	function Message():void
		{
			;
		}

		public	function toString():String
		{
			var result:Array = new Array();
			result.push(rid.toString());
			result.push(command);
			result = result.concat(param);
			if (isText)
				result.push('/p/r');
			return result.join(' ');
		}
	}
	
}
