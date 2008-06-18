/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.constants.ListType;
	import com.mobsword.natelib.data.FriendData;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	public class Friend
	{
		public	var data:FriendData;
		
		public	function Friend(fd:FriendData)
		{
			data = fd;
		}

		public	function invite(s:Session):void
		{
			;
		}

		public	function block():void
		{
			var m:Message = data.account.mm.genADDB(data.email, data.id, ListType.BLOCKED);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		public	function unblock():void
		{
			var m:Message = data.account.mm.genADDB(data.email, data.id, ListType.ALLOWED);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		public	function remove():void
		{
			var m:Message = data.account.mm.genRMVB(data.email, data.id, ListType.FOWARD);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		public	function move(g:Group):void
		{
			var m:Message = data.account.mm.genMVBG(data.email, data.id, data.group.data.id, g.data.id);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}
	}
}


