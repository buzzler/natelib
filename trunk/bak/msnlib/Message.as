package msnlib
{
	import mx.utils.StringUtil;
	
	public class Message
	{
		public static var CONTENT_TYPE_PROFILE		:String = "x-msmsgsprofile";
		public static var CONTENT_TYPE_INIT_EMAIL	:String = "x-msmsgsinitialemailnotification";
		public static var CONTENT_TYPE_NEW_EMAIL	:String = "x-msmsgsemailnotification";
		public static var CONTENT_TYPE_MAILBOX		:String = "x-msmsgsactivemailnotification";
		public static var CONTENT_TYPE_SYSTEM		:String = "x-msmsgssystemmessage";
		
		public var MIME_Version		:String;
		public var Content_Type		:String;
		public var charset			:String;
		public var LoginTime		:String;
		public var EmailEnabled		:String;
		public var MemberIdHigh		:String;
		public var MemberIdLow		:String;
		public var lang_preference	:String;
		public var preferredEmail	:String;
		public var country			:String;
		public var PostalCode		:String;
		public var Gender			:String;
		public var Kid				:String;
		public var Age				:String;
		public var BDayPre			:String;
		public var Birthday			:String;
		public var Wallet			:String;
		public var Flags			:String;
		public var sid				:String;
		public var kv				:String;
		public var MSPAuth			:String;
		public var ClientIP			:String;
		public var ClientPort		:String;
		
		public var Inbox_Unread		:String;
		public var Folders_Unread	:String;
		public var Inbox_URL		:String;
		public var Folders_URL		:String;
		public var Post_URL			:String;
		
		public var From				:String;
		public var Message_URL		:String;
		public var Subject			:String;
		public var Dest_Folder		:String;
		public var From_Addr		:String;
		public var id				:String;
		
		public var Src_Folder		:String;
		public var Message_Delta	:String;
		
		public var Type				:String;
		public var Arg1				:String;

		public function Message():void
		{
			;
		}
		public function dispatchMessage(msg:String):void
		{
			var headerAry:Array = StringUtil.trim(msg).split("\r\n");
			var header:Array;
			var i:int;
			for (i = 0 ; i < headerAry.length ; i++)
			{
				header = StringUtil.trim(headerAry[i]).split(": ");
				switch (header[0])
				{
					case "MIME-Version":
						MIME_Version = header[1];
						break;
					case "Content-Type":
						Content_Type = header[1].substring(header[1].indexOf("/")+1, header[1].indexOf(";"));
						charset = header[1].substring(header[1].indexOf("=")+1, header[1].length-1);
						break;
					case "LoginTime":
						LoginTime = header[1];
						break;
					case "EmailEnabled":
						EmailEnabled = header[1];
						break;
					case "MemberIdHigh":
						MemberIdHigh = header[1];
						break;
					case "MemberIdLow":
						MemberIdLow = header[1];
						break;
					case "lang_preference":
						lang_preference = header[1];
						break;
					case "preferredEmail":
						preferredEmail = header[1];
						break;
					case "country":
						country = header[1];
						break;
					case "PostalCode":
						PostalCode = header[1];
						break;
					case "Gender":
						Gender = header[1];
						break;
					case "Kid":
						Kid = header[1];
						break;
					case "Age":
						Age = header[1];
						break;
					case "BDayPre":
						BDayPre = header[1];
						break;
					case "Birthday":
						Birthday = header[1];
						break;
					case "Wallet":
						Wallet = header[1];
						break;
					case "Flags":
						Flags = header[1];
						break;
					case "sid":
						sid = header[1];
						break;
					case "kv":
						kv = header[1];
						break;
					case "MSPAuth":
						MSPAuth = header[1];
						break;
					case "ClientIP":
						ClientIP = header[1];
						break;
					case "ClientPort":
						ClientPort = header[1];
						break;
					case "Inbox-Unread":
						Inbox_Unread = header[1];
						break;
					case "Folders-Unread":
						Folders_Unread = header[1];
						break;
					case "Inbox-URL":
						Inbox_URL = header[1];
						break;
					case "Folders-URL":
						Folders_URL = header[1];
						break;
					case "Post-URL":
						Post_URL = header[1];
						break;
					case "From":
						From = header[1];
						break;
					case "Message-URL":
						Message_URL = header[1];
						break;
					case "Post-URL":
						Post_URL = header[1];
						break;
					case "Subject":
						Subject = header[1];
						break;
					case "Dest-Folder":
						Dest_Folder = header[1];
						break;
					case "From-Addr":
						From_Addr = header[1];
						break;
					case "id":
						id = header[1];
						break;
					case "Src-Folder":
						Src_Folder = header[1];
						break;
					case "Message-Delta":
						Message_Delta = header[1];
						break;
					case "Type":
						Type = header[1];
						break;
					case "Arg1":
						Arg1 = header[1];
						break;
				}
			}
		}
	}
}