/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.comm.AccountConnector;
	import com.mobsword.natelib.constants.AccountState;
	import com.mobsword.natelib.constants.Info;
	import com.mobsword.natelib.data.AccountData;
	import com.mobsword.natelib.events.Radio;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.managers.AccountManager;
	import com.mobsword.natelib.managers.FriendManager;
	import com.mobsword.natelib.managers.GroupManager;
	import com.mobsword.natelib.managers.MessageManager;
	import com.mobsword.natelib.managers.SessionManager;
	
	import flash.events.EventDispatcher;

	[Event(name = "STATE_CHANGE",	type = "com.mobsword.natelib.events.AccountEvent")]
	[Event(name = "NICK_CHANGE",	type = "com.mobsword.natelib.events.AccountEvent")]
	[Event(name = "NEW_FRIEND",		type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "NICK_CHANGE",	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "STATE_CHANGE",	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "LIST_CHANGE",	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "GROUP_CHANGE",	type = "com.mobsword.natelib.events.FriendEvent")]
	[Event(name = "NEW_GROUP",		type = "com.mobsword.natelib.events.GroupEvent")]
	[Event(name = "RENAME_GROUP",	type = "com.mobsword.natelib.events.GroupEvent")]
	[Event(name = "REMOVE_GROUP",	type = "com.mobsword.natelib.events.GroupEvent")]
	[Event(name = "NEW_SESSION",	type = "com.mobsword.natelib.events.SessionEvent")]
	[Event(name = "INVITE_SESSION",	type = "com.mobsword.natelib.events.SessionEvent")]

	/**
	 * 사용자 계정 클래스이다.
	 * 사용자가 접속하고자 하는 계정을 나타낸다.
	 * 친구, 그룹, 계정 관리를 이 클래스를 통해서 할 수 있다.
	 */
	public class Account extends EventDispatcher
	{
		public	var data	:AccountData;
		public	var radio	:Radio;
		private	var conn	:AccountConnector;
		public	var am		:AccountManager;
		public	var gm		:GroupManager;
		public	var fm		:FriendManager;
		public	var sm		:SessionManager;
		public	var mm		:MessageManager;

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
			radio	= new Radio();
			conn	= new AccountConnector(this);
			am		= new AccountManager(this);
			gm		= new GroupManager(this);
			fm		= new FriendManager(this);
			sm		= new SessionManager(this);
			mm		= new MessageManager(this);
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
		public	function connect(email:String, password:String, state:String):void
		{
			data.email		= email;
			data.password	= password;
			data.t_state	= state;
			
			conn.open(Info.HOST, Info.PORT);
		}

		/**
		 * 서버와의 접속을 끊기 위한 메소드.
		 * 접속이 끊김과 동시에 친구목록, 그룹목록, 세션목록등이 초기화된다.
		 * 
		 * @see	hidden
		 */
		public	function disconnect():void
		{
			conn.close();
			constructor();
		}
		
		/**
		 * 사용자의 상태를 '온라인'으로 변경한다.
		 */
		public	function online():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.ONLINE)), true);
		}
		
		/**
		 * 사용자의 상태를 '바쁨'으로 변경한다.
		 */
		public	function busy():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.BUSY)), true);
		}
		
		/**
		 * 사용자의 상태를 '자리비움'으로 변경한다.
		 */
		public	function away():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.AWAY)), true);
		}
		
		/**
		 * 사용자의 상태를 '통화중'으로 변경한다.
		 */
		public	function phone():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.PHONE)), true);
		}
		
		
		/**
		 * 사용자의 상태를 '회의중'으로 변경한다.
		 */
		public	function meet():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.MEET)), true);
		}
		
		/**
		 * 사용자의 상태를 '오프라인'으로 변경한다.
		 * 모든 친구 목록의 상대에게 '오프라인'으로 보이지만 접속이 끊긴 상태는 아니다.
		 * 
		 * @see offline
		 */
		public	function hidden():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genONST(AccountState.HIDDEN)), true);
		}

		public	function rename(name:String):void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genCNIK(name)), true);
		}
		
		/**
		 * 새로운 그룹을 추가한다.
		 * 
		 * @see Group.remove
		 */
		public	function addGroup(name:String):void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genADDG(name)), true);
		}
		
		/**
		 * 새로운 친구를 추가한다.
		 * 
		 * @see Friend.remove
		 */
		public	function addFriend(email:String, g:Group, msg:String):void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genADSB(email, g.data.id, msg)), true);
		}
		
		/**
		 * 새로운 대화 새션을 추가한다.
		 */
		public function addSession():void
		{
			radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mm.genRESS()));
		}
	}
	
}
