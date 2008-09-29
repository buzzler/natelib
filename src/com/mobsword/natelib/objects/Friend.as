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
	
	import flash.events.EventDispatcher;
	
	/**
	 * 친구를 나타내는 클래스이다.
	 * FL, AL, BL, RL 에 담긴 모든 대화상대는 이 객체로 표현된다.
	 */
	[Event(name = "NICK_CHANGE", 	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "STATE_CHANGE", 	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "LIST_CHANGE", 	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "GROUP_CHANGE", 	type = "com.mobsword.natelib.events.FriendEvent")]
	public class Friend extends EventDispatcher
	{
		public	var data:FriendData;
		
		public	function Friend(fd:FriendData)
		{
			data = fd;
		}

		/**
		 * 친구를 특정 세션으로 초대한다. 
		 * @param	s	세션객체
		 */
		public	function invite(s:Session):void
		{
			var invt:Message = data.account.mm.genINVT(s.data.host, s.data.port, s.data.id);
			var ctoc:Message = data.account.mm.genCTOC(data.email, invt);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, ctoc));
		}

		/**
		 * 친구를 차단한다. 상대방은 사용자의 상태를 알 수 없게 된다.
		 */
		public	function block():void
		{
			var m:Message = data.account.mm.genADDB(data.email, data.id, ListType.BLOCKED);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		/**
		 * 친구를 차단 해제한다.
		 */
		public	function unblock():void
		{
			var m:Message = data.account.mm.genADDB(data.email, data.id, ListType.ALLOWED);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		/**
		 * 친구를 대화상대 리스트로부터 삭제한다.
		 */
		public	function remove():void
		{
			var m:Message = data.account.mm.genRMVB(data.email, data.id, ListType.FOWARD);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}

		/**
		 * 친구의 그룹을 변경한다.
		 * @param	g	이동시킬 새로운 그룹 객체.
		 */
		public	function move(g:Group):void
		{
			var m:Message = data.account.mm.genMVBG(data.email, data.id, data.group.data.id, g.data.id);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m), true);
		}
	}
}


