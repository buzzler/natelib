/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.data.UserData;
	import com.mobsword.natelib.managers.ConnectionManager;
	import com.mobsword.natelib.managers.FriendManager;
	import com.mobsword.natelib.managers.GroupManager;
	import com.mobsword.natelib.managers.SessionManager;
	import flash.events.EventDispatcher;

	/**
	 * 사용자 계정 클래스이다.
	 * 사용자가 접속하고자 하는 계정을 나타낸다.
	 * 친구, 그룹, 계정 관리를 이 클래스를 통해서 할 수 있다.
	 */
	public class Account extends EventDispatcher
	{
		public	var data:AccountData;
		public	var cm	:ConnectionManager;
		public	var gm	:GroupManager;
		public	var fm	:FriendManager;
		public	var sm	:SessionManager;

		/**
		 * 생성자
		 */
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
		
		/**
		 * 네이트온에 접속하기 위한 메소드.
		 * 
		 * @param	email		사용자 아이디
		 * @param	password	패스워드
		 * @param	state		접속시 사용자 상태
		 */
		public	function online(email:String, password:String, state:String):void
		{
			data.email		= email;
			data.password	= password;
			data.state		= state;
		}

		/**
		 * 서버와의 접속을 끊기 위한 메소드.
		 * 접속이 끊김과 동시에 친구목록, 그룹목록, 세션목록등이 초기화된다.
		 * 
		 * @see	hidden
		 */
		public	function offline():void
		{
			;
		}
		
		/**
		 * 사용자의 상태를 '바쁨'으로 변경한다.
		 */
		public	function busy():void
		{
			;
		}
		
		/**
		 * 사용자의 상태를 '자리비움'으로 변경한다.
		 */
		public	function away():void
		{
			;
		}
		
		/**
		 * 사용자의 상태를 '통화중'으로 변경한다.
		 */
		public	function phone():void
		{
			;
		}
		
		
		/**
		 * 사용자의 상태를 '회의중'으로 변경한다.
		 */
		public	function meet():void
		{
			;
		}
		
		/**
		 * 사용자의 상태를 '오프라인'으로 변경한다.
		 * 모든 친구 목록의 상대에게 '오프라인'으로 보이지만 접속이 끊긴 상태는 아니다.
		 * 
		 * @see offline
		 */
		public	function hidden():void
		{
			;
		}
		
		/**
		 * 새로운 그룹을 추가한다.
		 * 
		 * @see Group.remove
		 */
		public	function addGroup():void
		{
			;
		}
		
		/**
		 * 새로운 친구를 추가한다.
		 * 
		 * @see Friend.remove
		 */
		public	function addFriend():void
		{
			;
		}
	}
	
}
