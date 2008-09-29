package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.data.GroupData;
	import com.mobsword.natelib.events.RadioEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	* 사용자그룹 클래스이다.
	* @author Default
	*/
	[Event(name = "RENAME_GROUP", type = "com.mobsword.natelib.events.GroupEvent")]
	[Event(name = "REMOVE_GROUP", type = "com.mobsword.natelib.events.GroupEvent")]
	public class Group extends EventDispatcher
	{
		public	var data:GroupData;
		
		public	function Group(gd:GroupData)
		{
			data = gd;
		}
		
		/**
		 * 현제 객체가 나타내는 그룹을 삭제한다.
		 * 만약 그룹 안에 다른 대화상대가 있는경우 삭제는 실패하게 된다.
		 */
		public	function remove():void
		{
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, data.account.mm.genRMVG(data.id)), true);
		}
		
		/**
		 * 객체의 이름을 변경한다.
		 * @param	name	새로운 그룹이름
		 */
		public	function rename(name:String):void
		{
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, data.account.mm.genRENG(data.id, name)), true);
		}
	}
}

