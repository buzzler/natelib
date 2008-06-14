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
		public	var	data	:String;
		public	var isBinary:Boolean;
		public	var isText	:Boolean;

		public	function Message():void
		{
			;
		}

		public	function toString():String
		{
			var result:Array = new Array();
			result.push(command);

			if (isText)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				return result.join(' ') + '\r\n';
			}
			else if (isBinary)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				if (data == null)
					data = '';
				result.push(data.length.toString() + '\r\n' + data);
				return result.join(' ');
			}
			else
			{
				if (param != null)
					result = result.concat(param);
				return result.join(' ');
			}
			return '';
		}
	}
}
