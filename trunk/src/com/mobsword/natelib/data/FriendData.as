package com.mobsword.natelib.data
{
	import com.mobsword.natelib.objects.Account;
	import com.mobsword.natelib.objects.Group;
	
	
	/**
	* ...
	* @author Default
	*/
	public class FriendData
	{
		public	var	account	:Account;	//����� ����
		public	var id		:String;	//������
		public	var index	:int;		//�׸� ����
		public	var name	:String;	//ģ�� �̸�
		public	var email	:String;	//ģ�� �̸���
		public	var nick	:String;	//ģ�� ����	
		public	var state	:String;	//ģ�� ����
		public	var mobile	:String;	//ģ�� ��ȭ��ȣ
		public	var birth	:String;	//ģ�� ����
		public	var block	:Boolean;	//���� ����
		public	var forward	:Boolean;	//��ȭ����� ģ�� ����
		public	var allow	:Boolean;	//��ȭ ��� ����� ģ������
		public	var reverse	:Boolean;	//��ȭ ��� �߰� ����� ģ������
		public	var group	:Group;		//ģ���� �Ҽӵ� �׷�
	}
}

