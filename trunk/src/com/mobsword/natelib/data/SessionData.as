package com.mobsword.natelib.data
{
	import com.mobsword.natelib.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionData
	{
		public	var account:Account;	//사용자 계정
		public	var id:String;			//세션 고유값
		public	var host:String;		//세션 아이피
		public	var port:int;			//세션 포트번호
		public	var friends:Array;		//참석자들
		
		public	function SessionData():void
		{
			friends = new Array();
		}
	}
	
}