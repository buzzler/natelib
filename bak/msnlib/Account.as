package msnlib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.utils.ObjectUtil;

	public class Account extends EventDispatcher
	{
		public static var STATUS_AVAILABLE	:String	= "NLN";
		public static var STATUS_BUSY		:String	= "BSY";
		public static var STATUS_IDLE		:String	= "IDL";
		public static var STATUS_BERIGHTBACK:String	= "BRB";
		public static var STATUS_AWAY		:String	= "AWY";
		public static var STATUS_PHONE		:String	= "PHN";
		public static var STATUS_LUNCH		:String	= "LUN";
		public static var STATUS_HIDDEN		:String	= "HDN";
		public static var STATUS_DISAVAILABLE:String= "FLN";
		
		private	var	ns		:NotificationServer;
		private var sbm		:SwitchboardManager;
		private	var	user	:String;
		private	var	password:String;
		public	var nick	:String;
		public	var	today	:String;
		public	var	status	:String;
		public	var	profile	:Message;
		public	var	groups	:Array;
		public	var	buddies	:Array;
		public	var sessions:Array;

		public function Account():void
		{
			ns = new NotificationServer();
			ns.addEventListener(NotificationServerEvent.DISCONNECT, onDisconnect);
			ns.addEventListener(NotificationServerEvent.LOGIN, onLogin);
			ns.addEventListener(NotificationServerEvent.UNAUTHORIZED, onLoginFail);
			ns.addEventListener(NotificationServerEvent.MESSAGE_PROFILE, onProfile);
			ns.addEventListener(NotificationServerEvent.RENAME, onRename);
			ns.addEventListener(NotificationServerEvent.BUDDY, onBuddies);
			ns.addEventListener(NotificationServerEvent.GROUP, onGroups);
			ns.addEventListener(NotificationServerEvent.TODAY, onToday);
			ns.addEventListener(NotificationServerEvent.STATUS, onStatus);
			ns.addEventListener(NotificationServerEvent.BUDDY_ADD, onAddBuddy);
			ns.addEventListener(NotificationServerEvent.BUDDY_DEL, onDelBuddy);
			ns.addEventListener(NotificationServerEvent.BUDDY_STATUS, onBuddyStatus);
			ns.addEventListener(NotificationServerEvent.BUDDY_BLOCK, onBlockBuddy);
			ns.addEventListener(NotificationServerEvent.BUDDY_UNBLOCK, onUnblockBuddy);
			ns.addEventListener(NotificationServerEvent.GROUP_ADD, onAddGroup);
			ns.addEventListener(NotificationServerEvent.GROUP_DEL, onDelGroup);
			sbm = ns.sbm;
			sbm.addEventListener(SwitchboardEvent.ANSWER, onAnswer);
			sbm.addEventListener(SwitchboardEvent.CALLING, onCalling);
			groups = new Array();
			buddies = new Array();
			sessions = new Array();
		}
		public function outMessage(sid:String):void
		{
			this.sbm.outSession(sid);
		}
		public function sendMessage(sid:String, msg:String):void
		{
			if (sid != null) 
				var sb:Switchboard = sbm.whichSession(sid);
			if (sb == null)
				return;
			sb.talkSession(msg);
		}
		public function callBuddy(sid:String, user:String):void
		{
			if (sid != null)
			{
				var sb:Switchboard = sbm.whichSession(sid);
				if (sb != null)
					sb.inviteBuddy(user);
			}
			else
				ns.requestSwitchboard(user);
		}
		private function onAnswer(e:SwitchboardEvent):void
		{
			var s:Session = new Session();
			s.sid = e.sid;
			s.users = e.roaster_user;
			s.nicks = e.roaster_nick;
			sessions.push(s);
			var sb:Switchboard = sbm.getSwitchboard(s.sid);
			if (sb == null)
			{
				trace("ERR: Can not find switchboard object");
				return;
			}
			sb.addEventListener(SwitchboardEvent.MESSAGE, onMessage);
			sb.addEventListener(SwitchboardEvent.BYE, onBye);
			sb.addEventListener(SwitchboardEvent.JOIN, onJoin);
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.ANSWER);
			sbe.sid = e.sid;
			dispatchEvent(sbe);
		}
		private function onCalling(e:SwitchboardEvent):void
		{
			var i:int = hasSessionIndex(e.sid);
			if (i < 0)
			{
				var s:Session = new Session();
				s.sid = e.sid;
				sessions.push(s);
				var sb:Switchboard = sbm.getSwitchboard(s.sid);
				if (sb == null)
				{
					trace("ERR: Can not find switchboard object");
					return;
				}
				sb.addEventListener(SwitchboardEvent.MESSAGE, onMessage);
				sb.addEventListener(SwitchboardEvent.BYE, onBye);
				sb.addEventListener(SwitchboardEvent.JOIN, onJoin);
				sb.addEventListener(SwitchboardEvent.CONTROL, onControl);
				var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.CALLING);
				sbe.sid = e.sid;
				dispatchEvent(sbe);
			}
		}
		private function onMessage(e:SwitchboardEvent):void
		{
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.MESSAGE);
			sbe.sid = e.sid;
			sbe.roaster_user = e.roaster_user;
			sbe.roaster_nick = e.roaster_nick;
			sbe.message = e.message;
			sbe.color = e.color;
			sbe.isBold = e.isBold;
			sbe.isItalic = e.isItalic;
			sbe.isUnderline = e.isUnderline;
			dispatchEvent(sbe);
		}
		private function onBye(e:SwitchboardEvent):void
		{
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.BYE);
			sbe.sid = e.sid;
			sbe.roaster_user = e.roaster_user;
			sbe.roaster_nick = e.roaster_nick;
			dispatchEvent(sbe);
		}
		private function onJoin(e:SwitchboardEvent):void
		{
			var ss:Session = this.sessions[this.hasSessionIndex(e.sid)] as Session;
			ss.nicks = e.roaster_nick;
			ss.users = e.roaster_user;
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.JOIN);
			sbe.sid = e.sid;
			sbe.roaster_user.push(e.roaster_user[e.roaster_user.length-1]);
			sbe.roaster_nick.push(e.roaster_nick[e.roaster_nick.length-1]);
			dispatchEvent(sbe);
		}
		private function onControl(e:SwitchboardEvent):void
		{
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.CONTROL);
			sbe.sid = e.sid;
			sbe.roaster_nick.push(e.roaster_nick[0]);
			sbe.roaster_user.push(e.roaster_user[0]);
			dispatchEvent(sbe);
		}
		public function onDisconnect(e:NotificationServerEvent):void
		{
			sbm.outAllSession();
			dispatchEvent(new AccountEvent(AccountEvent.LOGOUT));
		}
		public function login(user:String, password:String, status:String):void
		{
			this.user = user;
			this.password = password;
			ns.connect(user, password, status);
		}
		public function signout():void
		{
			ns.disconnect();
		}
		public function setStatus(status:String):void
		{
			ns.setStatus(status);
		}
		public function renameAccount(name:String):void
		{
			ns.renameAccount(this.user, name);
		}
		public function moveBuddy(user:String, sGid:String, dGid:String):void
		{
			var b:Buddy = this.whichBuddy(user);
			if (b == null)
				return;
			ns.moveBuddy(b.CID, sGid, dGid);
		}
		public function addBuudy(user:String):void
		{
			ns.addBuddy(user);
		}
		public function delBuddy(user:String, blocked:Boolean = true):void
		{
			ns.delBuddy(whichBuddy(user), blocked);
		}
		public function blockBuddy(user:String):void
		{
			ns.blockBuddy(whichBuddy(user));
		}
		public function unblockBuddy(user:String):void
		{
			ns.unblockBuddy(whichBuddy(user));
		}
		public function blockGroup(id:String):void
		{
			ns.blockGroup(whichGroup(id));
		}
		public function unblockGroup(id:String):void
		{
			ns.unblockGroup(whichGroup(id));
		}
		public function addGroup(name:String):void
		{
			ns.addGroup(name);
		}
		public function delGroup(id:String):void
		{
			ns.delGroup(id);
		}
		public function renameGroup(id:String, name:String):void
		{
			ns.renameGroup(id, name);
		}

		private function onLogin(event:NotificationServerEvent):void
		{
			this.status = event.status;
			dispatchEvent(new AccountEvent(AccountEvent.LOGIN));
		}
		private function onLoginFail(event:NotificationServerEvent):void
		{
			dispatchEvent(new Event(AccountEvent.FAIL));
		}
		private function onProfile(event:NotificationServerEvent):void
		{
			profile = event.message;
		}
		private function onRename(event:NotificationServerEvent):void
		{
			this.nick = event.nick;
			dispatchEvent(new AccountEvent(AccountEvent.RENAME));
		}
		private function onBuddies(event:NotificationServerEvent):void
		{
			if (this.groups.length < 1)
			{
				trace("NO GROUP");
				var end:Group = new Group();
				end.name = "Other Contacts";
				end.id = "Other Contacts";
				this.groups.push(end);
			}
			this.buddies = event.buddy;
			this.buddies.sortOn("user");
			var i:int;
			var j:int;
			var h:int;
			for (h = 0 ; h < buddies.length ; h++)
			{
				if (buddies[h].groupIDs.length < 1)
					continue;
				for (i = 0 ; i < buddies[h].groupIDs.length ; i++)
				{
					for (j = 0 ; j < groups.length ; j++)
					{
						if (groups[j].id == buddies[h].groupIDs[i])
							groups[j].buddies.push(buddies[h]);
					}
				}
			}
			dispatchEvent(new AccountEvent(AccountEvent.BUDDY));
		}
		private function onGroups(event:NotificationServerEvent):void
		{
			this.groups = event.group;
			groups.sortOn("id");
			dispatchEvent(new AccountEvent(AccountEvent.GROUP));
		}
		private function onToday(event:NotificationServerEvent):void
		{
			this.today = event.today;
			dispatchEvent(new AccountEvent(AccountEvent.STATUS));
		}
		private function onStatus(event:NotificationServerEvent):void
		{
			this.status = event.status;
			dispatchEvent(new AccountEvent(AccountEvent.STATUS));
		}
		private function onAddBuddy(event:NotificationServerEvent):void
		{
			var b:Buddy = event.buddy[0] as Buddy;
			this.buddies.push(b);
			for each(var gid:String in b.groupIDs)
				for each(var g:Group in this.groups)
					if (g.id == gid)
					{
						g.buddies.push(b);
						break;
					}
			this.buddies.push(b);
			this.buddies.sortOn("user");
			for each(var gg:Group in groups)
				if (gg.id == b.groupIDs[0])
					gg.buddies.push(b);
			var ae:AccountEvent = new AccountEvent(AccountEvent.BUDDY_ADD);
			ae.value = b;
			dispatchEvent(ae);
		}
		private function onDelBuddy(event:NotificationServerEvent):void
		{
			var cid:String = (event.buddy[0] as Buddy).CID;
			for each(var b:Buddy in this.buddies)
				if (b.CID == cid)
				{
					this.buddies.splice(this.buddies.indexOf(b),1);
					break;
				}
			for each(var g:Group in this.groups)
				for each(var bb:Buddy in g.buddies)
					if (bb.CID == cid)
						this.groups.splice(groups.indexOf(bb),1);
			var ae:AccountEvent = new AccountEvent(AccountEvent.BUDDY_DEL);
			ae.value = b;
			dispatchEvent(ae);
		}
		private function onBuddyStatus(event:NotificationServerEvent):void
		{
			// event.buddy = Array[status, user, nick, clientID]
			var buddy:Buddy = whichBuddy(event.buddy[1]);
			if (buddy == null)
				return;
			buddy.status = event.buddy[0];
			if (buddy.status != Account.STATUS_DISAVAILABLE)
			{
				buddy.nick = event.buddy[2];
				buddy.clientID = event.buddy[3];
			}
			var ae:AccountEvent = new AccountEvent(AccountEvent.BUDDY_STATUS);
			ae.value = buddy;
			dispatchEvent(ae);
		}
		private function onBlockBuddy(event:NotificationServerEvent):void
		{
			var b:Buddy = whichBuddy(event.user);
			b.isAllow = false;
			b.isBlock = true;
			var ve:AccountEvent = new AccountEvent(AccountEvent.BUDDY_BLCOK);
			ve.value = b;
			dispatchEvent(ve);
		}
		private function onUnblockBuddy(event:NotificationServerEvent):void
		{
			var b:Buddy = whichBuddy(event.user);
			b.isAllow = true;
			b.isBlock = false;
			var ve:AccountEvent = new AccountEvent(AccountEvent.BUDDY_UNBLCOK);
			ve.value = b;
			dispatchEvent(ve);
		}
		private function onAddGroup(event:NotificationServerEvent):void
		{
			var ae:AccountEvent = new AccountEvent(AccountEvent.GROUP_ADD);
			var g:Group = event.group[0] as Group;
			ae.value = g;
			this.groups.push(g);
			groups.sortOn("id");
			dispatchEvent(ae);
		}
		private function onDelGroup(event:NotificationServerEvent):void
		{
			var ae:AccountEvent = new AccountEvent(AccountEvent.GROUP_DEL);
			for each(var g:Group in this.groups)
			{
				if (g.id == event.group[0])
				{
					ae.value = g;
					break;
				}
			}
			this.groups.splice(groups.indexOf(g),1);
			dispatchEvent(ae);
		}
		private function onSwitchboard(event:SwitchboardEvent):void
		{
			dispatchEvent(event);
		}
		public function hasSessionIndex(sid:String):int
		{
			var i:int;
			for (i = 0 ; i < this.sessions.length ; i++)
			{
				if (this.sessions[i].sid == sid)
					return i;
			}
			return -1;
		}
		public function hasSession(sid:String):Session
		{
			var i:int;
			for (i = 0 ; i < this.sessions.length ; i++)
			{
				if (this.sessions[i].sid == sid)
					return this.sessions[i] as Session;
			}
			return null;
		}
		private function whichBuddy(user:String):Buddy
		{
			var result:int;
			var start:int = 0;
			var seek:int;
			var end:int = this.buddies.length-1;
			while (true)
			{
				seek = Math.round((start+end) / 2);
				result = user.localeCompare(this.buddies[seek].user);
				if (result < 0)
				{
					end = seek-1;;
				}
				else if (result == 0)
				{
					return this.buddies[seek];
				}
				else if (result > 0)
				{
					start = seek + 1;
				}
				
				if (start > end)
					return null;
			}
			return null;
		}
		private function whichGroup(id:String):Group
		{
			var result:int;
			var start:int = 0;
			var seek:int;
			var end:int = this.groups.length-1;
			while (true)
			{
				seek = Math.round((start+end) / 2);
				result = id.localeCompare(this.groups[seek].id);
				if (result < 0)
				{
					end = seek-1;;
				}
				else if (result == 0)
				{
					return this.groups[seek];
				}
				else if (result > 0)
				{
					start = seek + 1;
				}
				
				if (start > end)
					return null;
			} 
			return null;
		}

	}
}