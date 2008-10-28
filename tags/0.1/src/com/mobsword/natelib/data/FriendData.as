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
		public	var	account	:Account;	//사용자 계정
		public	var id		:String;	//고유값
		public	var index	:int;		//항목별 순서
		public	var name	:String;	//친구 이름
		public	var email	:String;	//친구 이메일
		public	var nick	:String;	//친구 별명	
		public	var state	:String;	//친구 상태
		public	var mobile	:String;	//친구 전화번호
		public	var birth	:String;	//친구 생일
		public	var block	:Boolean;	//차단 상태
		public	var forward	:Boolean;	//대화목록의 친구 여부
		public	var allow	:Boolean;	//대화 허용 목록의 친구여부
		public	var reverse	:Boolean;	//대화 상대 추가 목록의 친구여부
		public	var group	:Group;		//친구가 소속된 그룹
	}
}

