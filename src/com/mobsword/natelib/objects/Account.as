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
	 * ����� ���� Ŭ�����̴�.
	 * ����ڰ� �����ϰ��� �ϴ� ������ ��Ÿ����.
	 * ģ��, �׷�, ���� ������ �� Ŭ������ ���ؼ� �� �� �ִ�.
	 */
	public class Account extends EventDispatcher
	{
		public	var data:AccountData;
		public	var cm	:ConnectionManager;
		public	var gm	:GroupManager;
		public	var fm	:FriendManager;
		public	var sm	:SessionManager;

		/**
		 * ������
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
		 * ����Ʈ�¿� �����ϱ� ���� �޼ҵ�.
		 * 
		 * @param	email		����� ���̵�
		 * @param	password	�н�����
		 * @param	state		���ӽ� ����� ����
		 */
		public	function online(email:String, password:String, state:String):void
		{
			data.email		= email;
			data.password	= password;
			data.state		= state;
		}

		/**
		 * �������� ������ ���� ���� �޼ҵ�.
		 * ������ ����� ���ÿ� ģ�����, �׷���, ���Ǹ�ϵ��� �ʱ�ȭ�ȴ�.
		 * 
		 * @see	hidden
		 */
		public	function offline():void
		{
			;
		}
		
		/**
		 * ������� ���¸� '�ٻ�'���� �����Ѵ�.
		 */
		public	function busy():void
		{
			;
		}
		
		/**
		 * ������� ���¸� '�ڸ����'���� �����Ѵ�.
		 */
		public	function away():void
		{
			;
		}
		
		/**
		 * ������� ���¸� '��ȭ��'���� �����Ѵ�.
		 */
		public	function phone():void
		{
			;
		}
		
		
		/**
		 * ������� ���¸� 'ȸ����'���� �����Ѵ�.
		 */
		public	function meet():void
		{
			;
		}
		
		/**
		 * ������� ���¸� '��������'���� �����Ѵ�.
		 * ��� ģ�� ����� ��뿡�� '��������'���� �������� ������ ���� ���´� �ƴϴ�.
		 * 
		 * @see offline
		 */
		public	function hidden():void
		{
			;
		}
		
		/**
		 * ���ο� �׷��� �߰��Ѵ�.
		 * 
		 * @see Group.remove
		 */
		public	function addGroup():void
		{
			;
		}
		
		/**
		 * ���ο� ģ���� �߰��Ѵ�.
		 * 
		 * @see Friend.remove
		 */
		public	function addFriend():void
		{
			;
		}
	}
	
}
