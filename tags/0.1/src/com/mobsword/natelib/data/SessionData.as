package com.mobsword.natelib.data
{
	import com.mobsword.natelib.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionData
	{
		public	var account:Account;	//����� ����
		public	var id:String;			//���� ������
		public	var host:String;		//���� ������
		public	var port:int;			//���� ��Ʈ��ȣ
		public	var friends:Array;		//�����ڵ�
		
		public	function SessionData():void
		{
			friends = new Array();
		}
	}
	
}