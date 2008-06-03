package msnlib
{
	import flash.net.Socket;
	import flash.errors.IOError;
	import mx.controls.Alert;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.errors.EOFError;
	import mx.utils.StringUtil;
	import flash.events.EventDispatcher;
	import flash.utils.*;

	public class NotificationServer extends EventDispatcher
	{
		private static	var DS_IP		:String	= "messenger.hotmail.com";
		private static	var DS_PORT		:int = 1863;
		private			var NS_IP		:String;
		private			var NS_PORT		:int;
		private			var LIST_VERSION:String = "2005-04-23T18:57:44.8130000-07:00 2005-04-23T18:57:54.2070000-07:00";
		private			var	CLIENT_ID	:uint = 276828192;
		private			var user		:String;						//패스포트 아이디
		private			var pwd			:String;						//패스포트 비밀번호
		private			var	statusTmp	:String;						//목표 상태
		private			var status		:String;						//현제상태
		private			var	presence	:Boolean;						//초기화상태
		private			var connection	:Socket;						//NS서버소켓
		private			var trid		:int;							//최근 트랜젝션 아이디
		private			var	trm			:TRManager;
		public			var	sbm			:SwitchboardManager;
		private			var	buddy_invite:String;
		private			var	numBuddies	:int;
		private			var	numGroups	:int;
		private			var	buddies		:Array;
		private			var groups		:Array;

		public function NotificationServer():void
		{
			presence = false;
			connection = new Socket();
			connection.addEventListener(ProgressEvent.SOCKET_DATA, dataListener);
			connection.addEventListener(Event.CLOSE, disconnectListener);
			trid = 0;
			trm = new TRManager();
			sbm = new SwitchboardManager();
			numBuddies = 0;
			numGroups = 0;
			buddies = new Array();
			groups = new Array();
		}
		private function send(cmd:String, param:String, newLine:Boolean = true):void
		{
			if (newLine)
				param += "\r\n";
			trid++;
			var cmd:String = cmd + " " + trid.toString() + " " + param;
			connection.writeUTFBytes(cmd);
			connection.flush();
			trace(cmd);
		}
		public function connect(user:String, pwd:String, status:String):Boolean
		{
			this.user = user;
			this.pwd = pwd;
			this.statusTmp = status;

			try
			{
				connection.connect(NotificationServer.DS_IP, NotificationServer.DS_PORT);
				send("VER", "MSNP11 MSNP10 CVR0");
			}
			catch (err:IOError)
			{
				Alert.show(err.message.toString());
				return false;
			}
			catch (err:SecurityError)
			{
				Alert.show(err.message.toString());
				return false;
			}

			return true;
		}
		public function disconnect():void
		{
			if (connection.connected)
				connection.close();
		}
		public function setStatus(status:String):void
		{
			this.statusTmp = status;
			send("CHG", this.statusTmp + " " + this.CLIENT_ID);
		}
		public function renameAccount(user:String, name:String):void
		{
			send("PRP", "MFN " + escape(name));
		}

		public function moveBuddy(cid:String, fromGid:String, toGid:String):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_MOVE);
			if (fromGid == "Other Contacts")
			{
				send("ADC", "FL C="+cid+" "+toGid);
				trm.addTR(this.trid);
				return;
			}
			if (toGid == "Other Contacts")
			{
				send("REM", "FL "+cid+" "+fromGid);
				trm.addTR(this.trid);
				return;
			}
			send("ADC", "FL C="+cid+" "+toGid);
			trm.addTR(this.trid);
			send("REM", "FL "+cid+" "+fromGid);
			trm.addTR(this.trid);
		}

		public function addBuddy(user:String):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_ADD);
			send("ADC", "AL N=" + escape(user));
			trm.addTR(this.trid);
			send("ADC", "FL N=" + escape(user) + " F=" + escape(user));
			trm.addTR(this.trid);
		}
		public function delBuddy(buddy:Buddy, blocked:Boolean = true):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_DEL);
			send("REM", "FL " + buddy.CID);
			trm.addTR(this.trid);
			send("REM", "AL " + buddy.user);
			trm.addTR(this.trid);
		}
		public function delBuddy2(buddy:Buddy, blocked:Boolean = true):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_DEL);

			if (blocked)
			{
				if (buddy.isAllow)
				{
					send("REM", "AL " + buddy.user);
					trm.addTR(this.trid);
				}
				if (!buddy.isBlock)
				{
					send("ADC", "BL N=" + buddy.user);
					trm.addTR(this.trid);
				}
			}
			else
			{
				if (!buddy.isAllow)
				{
					send("ADC", "AL N=" + buddy.user);
					trm.addTR(this.trid);
				}
				if (buddy.isBlock)
				{
					send("REM", "BL " + buddy.user);
					trm.addTR(this.trid);
				}
			}
			if (buddy.isForward)
			{
				send("REM", "FL " + buddy.CID);
				trm.addTR(this.trid);
			}
		}
		public function blockBuddy(buddy:Buddy):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_BLOCK);
			if (buddy.isAllow)
			{
				send("REM", "AL " + buddy.user);
				trm.addTR(this.trid);
			}
			if (!buddy.isBlock)
			{
				send("ADC", "BL N=" + buddy.user);
				trm.addTR(this.trid);
			}
		}
		public function unblockBuddy(buddy:Buddy):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_UNBLOCK);
			if (!buddy.isAllow)
			{
				send("ADC", "AL N=" + buddy.user);
				trm.addTR(this.trid);
			}
			if (buddy.isBlock)
			{
				send("REM", "BL " + buddy.user);
				trm.addTR(this.trid);
			}
		}
		public function blockGroup(group:Group):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_BLOCK);
			var i:int;
			var total:int = group.buddies.length;
			for (i = 0 ; i < total ; i++)
			{
				if (buddies[i].isAllow)
				{
					send("REM", "AL " + buddies[i].user);
					trm.addTR(this.trid);
				}
				if (!buddies[i].isBlock)
				{
					send("ADC", "BL N=" + buddies[i].user);
					trm.addTR(this.trid);
				}
			}
		}
		public function unblockGroup(group:Group):void
		{
			trm.startTR(NotificationServerEvent.BUDDY_UNBLOCK);
			var i:int;
			var total:int = group.buddies.length;
			for (i = 0 ; i < total ; i++)
			{
				if (!buddies[i].isAllow)
				{
					send("ADC", "AL N=" + buddies[i].user);
					trm.addTR(this.trid);
				}
				if (buddies[i].isBlock)
				{
					send("REM", "BL " + buddies[i].user);
					trm.addTR(this.trid);
				}
			}
		}
		public function addGroup(name:String):void
		{
//			trm.startTR(NotificationServerEvent.GROUP_ADD);
			send("ADG", escape(name) + " 0");
//			trm.addTR(this.trid);
		}
		public function delGroup(id:String):void
		{
//			trm.startTR(NotificationServerEvent.GROUP_DEL);
			send("RMG", id);
//			trm.addTR(this.trid);
		}
		public function renameGroup(id:String, name:String):void
		{
			send("REG", id + " " + escape(name));
		}
		public function requestSwitchboard(user:String):void
		{
			this.buddy_invite = user;
			send("XFR", "SB");
		}
		private function disconnectListener(event:Event):void
		{
			dispatchEvent(new NotificationServerEvent(NotificationServerEvent.DISCONNECT));
		}
		private function dataListener(event:ProgressEvent):void
		{
			var i:int;
			var lines:Array;
			var connLen:uint = connection.bytesAvailable;
			try
			{
				lines = connection.readMultiByte(connLen, "utf-8").split("\r\n");
			}
			catch (err:EOFError)
			{
				trace(err.message.toString());
				return;
			}
			catch (err:SecurityError)
			{
				trace(err.message.toString());
				return;
			}
			catch (err:IOError)
			{
				trace(err.message.toString());
				return;
			}

			for (i = 0 ; i < lines.length ; i++)
			{
				trace(lines[i]);
				var cmd:Array = StringUtil.trim(lines[i]).split(" ");
				switch (cmd[0])
				{
					case "VER":							//VER - Protocol version
						exeVER();
						break;
					case "CVR":							//Sends version information
						exeCVR();
						break;
					case "XFR":							//Redirection to Notification server
						exeXFR(cmd);
						break;
					case "USR":							//Authentication command
						exeUSR(cmd);
						break;
					case "SBS":							//Unknown
						break;
					case "MSG":							//Initial profile download
						i += exeMSG(lines.slice(i+1), cmd[3]);
						break;
					case "SYN":							//Begin synchronization/download contact list
						exeSYN(cmd);
						break;
					case "GTC":							//Initial contact list/settings download
						break;
					case "BLP":							//Initial settings download
						break;
					case "PRP":							//Initial settings download - Mobile settings and display name
						exePRP(cmd);
						break;
					case "LSG":							//Initial contact list download - Groups
						exeLSG(cmd);
						break;
					case "LST":							//Initial contact list download - Contacts
						exeLST(cmd);
						break;
					case "GCF":							//Unknown
						trace(lines[i]);
						break;
					case "CHG":							//Change client's online status
						exeCHG(cmd);
						break;
					case "ILN":
						exeILN(cmd);
						break;
					case "ADC":							//Add users to your contact lists
						exeADC(cmd);
						break;
					case "REM":							//Remove users from your contact lists
						exeREM(cmd);
						break;
					case "REA":							//Rename your display name
						exeREA(cmd);
						break;
					case "ADG":							//Add group
						exeADG(cmd);
						break;
					case "REG":							//Rename group name
						exeREG(cmd);
						break;
					case "RMG":							//Remove group
						exeRMG(cmd);
						break;
					case "CHL":							//Client challenge
						exeCHL(cmd);
						break;
					case "QRY":							//Response to CHL by client
						trace(lines[i]);
						break;
					case "FLN":							//Principal signed off
						exeFLN(cmd);
						break;
					case "UUX":							//
						if (parseInt(cmd[2]) > 0)
						{
							exeUUX(lines[i+1]);
							i++;
						}
						break;
					case "UBX":
						i += exeUBX(cmd, lines, i+1);
						break;
					case "NLN":							//Principal changed presence/signed on
						exeNLN(cmd);
						break;
					case "RNG":
						exeRNG(cmd);
						break;
					case "SBP":							//
						trace(lines[i]);
						break;
					default:
						trace(lines[i]);
						break;
				}
			}
		}
		private function exeVER():void
		{
			send("CVR", "0x040c winnt 5.1 i386 MSNMSGR 7.0.0777 msmsgs "+user);
		}
		private function exeCVR():void
		{
			send("USR", "TWN I "+user);
		}
		private function exeXFR(cmd:Array):void
		{
			var ary:Array = cmd[3].split(':');
			switch (cmd[2])
			{
				case "NS":
					NS_IP = ary[0];
					NS_PORT = parseInt(ary[1]);

					connection.connect(NS_IP, NS_PORT);
					send("VER", "MSNP11 MSNP10 CVR0");
					break;
				case "SB":
					var address:Array = cmd[3].split(":");
					this.sbm.newSession(address[0], address[1], this.user, cmd[5], this.buddy_invite);
					break;
			}
		}
		private function exeUSR(cmd:Array):void
		{
			switch (cmd[2])
			{
 				case "TWN":
					var challenge:String = cmd[4];
					var auth:Authentication = new Authentication();
					auth.addEventListener(AuthenticationEvent.TICKET, exeUSRTWN);
					auth.addEventListener(AuthenticationEvent.UNAUTHORIZED, exeUSRUAT);
					auth.requestTicket(escape(user), escape(pwd), challenge);
					break;
				case "OK":
					send("SYN", LIST_VERSION);
					break;
			}
		}
		private function exeUSRTWN(event:Event):void
		{
			var t:String = event.target.ticket;
			send("USR", "TWN S " + t);
		}
		private function exeUSRUAT(event:Event):void
		{
			trace("LOGIN FAIL : UNAUTHORIZED");
			dispatchEvent(new NotificationServerEvent(NotificationServerEvent.UNAUTHORIZED));
		}
		private function exeMSG(cmd:Array, pl:int):int
		{
			var data:String = cmd.join("\r\n");
			var mime:String = data.slice(0, pl);
			var type:String;
			try
			{
				var nse:NotificationServerEvent;
				var msg:Message = new Message();
				msg.dispatchMessage(mime);
				switch (msg.Content_Type)
				{
					case Message.CONTENT_TYPE_PROFILE:
						nse = new NotificationServerEvent(NotificationServerEvent.MESSAGE_PROFILE);
						break;
					case Message.CONTENT_TYPE_INIT_EMAIL:
						nse = new NotificationServerEvent(NotificationServerEvent.MESSAGE_INIT_MAIL);
						break;
					case Message.CONTENT_TYPE_NEW_EMAIL:
						nse = new NotificationServerEvent(NotificationServerEvent.MESSAGE_NEW_MAIL);
						break;
					case Message.CONTENT_TYPE_MAILBOX:
						nse = new NotificationServerEvent(NotificationServerEvent.MESSAGE_MAILBOX);
						break;
					case Message.CONTENT_TYPE_SYSTEM:
						nse = new NotificationServerEvent(NotificationServerEvent.MESSAGE_SYSTEM);
						break;
					default:
						trace("Discard Message (Content-Type) : " + msg.Content_Type)
						break;
				}
				if (nse != null)
				{
					nse.message = msg;
					dispatchEvent(nse);
				}
				return mime.split("\r\n").length-1;
			}
			catch (err:EOFError)
			{
				trace(err.message.toString());
				return 0;
			}
			catch (err:IOError)
			{
				trace(err.message.toString());
				return 0;
			}
			trace("MSG NULL");
			return 0;
		}
		private function exeSYN(ary:Array):void
		{
			this.LIST_VERSION = "";
			var i:int;
			for (i = 2 ; i < ary.length-2 ; i++)
			{
				this.LIST_VERSION += ary[i] + " ";
			}
			this.LIST_VERSION = StringUtil.trim(this.LIST_VERSION);
			this.numBuddies = ary[(ary.length-2)];
			this.numGroups = ary[(ary.length-1)];
		}
		private function exePRP(cmd:Array):void
		{
			switch (cmd[1])
			{
				case "MFN":
					var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.RENAME);
					nse.nick = unescape(cmd[2]);
					dispatchEvent(nse);
					break;
				case "PHN":
					break;
				case "HSB":
					break;
				case "MBE":
					break;
				case "WWE":
					break;
			}
		}
		private function exeLST(cmd:Array):void
		{

			var bdy:Buddy = new Buddy();
			bdy.status = Account.STATUS_DISAVAILABLE;
			var i:int;
			for (i = 1; i < cmd.length ; i++)
			{
				switch (cmd[i].charAt(0))
				{
					case "N":
						bdy.user = unescape(cmd[i].substring(2, cmd[i].length));
						break;
					case "F":
						bdy.nick = unescape(cmd[i].substring(2, cmd[i].length));
						break;
					case "C":
						bdy.CID = unescape(cmd[i].substring(2, cmd[i].length));
						break;
					case "L":							//혹시 잘못 걸러진 LST명령 확인사살
						break;
					default:
						if (cmd[i].length < 5)			//3으로 해도 충분하다.
						{
							bdy.setListNumber(parseInt(cmd[i]));
							if (i == cmd.length-1)
								bdy.groupIDs.push("Other Contacts");
						}
						else
							bdy.groupIDs = cmd[i].split(",");
						break;
				}
			}
			buddies.push(bdy);
			if (this.numBuddies == this.buddies.length)
			{
				var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.BUDDY);
				nse.buddy = this.buddies;
				dispatchEvent(nse);
				if (!this.presence)
				{
					send("CHG", this.statusTmp+" "+this.CLIENT_ID.toString());
				}
			}
		}
		private function exeLSG(cmd:Array):void
		{
			var grp:Group = new Group();
			grp.name = unescape(cmd[1]);
			grp.id = cmd[2];
			groups.push(grp);
			if (this.numGroups == this.groups.length)
			{
				var end:Group = new Group();
				end.name = "Other Contacts";
				end.id = "Other Contacts";
				groups.push(end);
				var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.GROUP);
				nse.group = this.groups;
				dispatchEvent(nse);
			}
		}
		private function exeCHG(cmd:Array):void
		{
			if (cmd[2] == this.statusTmp)
			{
				this.presence = true;
				this.status = this.statusTmp;
				this.statusTmp = null;
				var nse:NotificationServerEvent;
				if (this.presence)
				{
					nse = new NotificationServerEvent(NotificationServerEvent.STATUS);
				}
				else
				{
					nse = new NotificationServerEvent(NotificationServerEvent.LOGIN);
					this.presence = true;
				}
				nse.status = this.status;
				dispatchEvent(nse);
			}
		}
		private function exeILN(cmd:Array):void
		{
			var i:int;
			for (i = 0 ; i < this.buddies.length ; i++)
			{
				if ((this.buddies[i] as Buddy).user == unescape(cmd[3]))
				{
					(this.buddies[i] as Buddy).status = cmd[2];
					break;
				}
			}
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.BUDDY_STATUS);
			nse.buddy = new Array();
			nse.buddy.push(cmd[2], unescape(cmd[3]), unescape(cmd[4]), cmd[5]);
			dispatchEvent(nse);
		}
		private function exeNLN(cmd:Array):void
		{
			var i:int;
			for (i = 0 ; i < this.buddies.length ; i++)
			{
				if ((this.buddies[i] as Buddy).user == unescape(cmd[2]))
				{
					(this.buddies[i] as Buddy).nick = unescape(cmd[3]);
					(this.buddies[i] as Buddy).status = cmd[1];
					break;
				}
			}
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.BUDDY_STATUS);
			nse.buddy = new Array();
			nse.buddy.push(cmd[1], unescape(cmd[2]), unescape(cmd[3]), cmd[4]);
			dispatchEvent(nse);
		}
		private function exeFLN(cmd:Array):void
		{
			var i:int;
			for (i = 0 ; i < this.buddies.length ; i++)
			{
				if ((this.buddies[i] as Buddy).user == unescape(cmd[1]))
				{
					(this.buddies[i] as Buddy).status = cmd[0];
					break;
				}
			}
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.BUDDY_STATUS);
			nse.buddy = new Array();
			nse.buddy.push(cmd[0], unescape(cmd[1]));
			dispatchEvent(nse);
		}
		private function exeADC2(cmd:Array):void
		{
			trace("ADC - " + cmd.toString());
			var nse:NotificationServerEvent;
			var ek:String = trm.checkTR(parseInt(cmd[1]));
			switch(cmd[2])
			{
				case "BL":
					nse = new NotificationServerEvent(NotificationServerEvent.BUDDY_BLOCK);
					nse.user = (cmd[3] as String).substr(2);
					dispatchEvent(nse);
					break;
				case "FL":
					nse = new NotificationServerEvent(NotificationServerEvent.BUDDY_ADD);
					var b:Buddy = new Buddy();
					b.user = (cmd[3] as String).substr(2);
					b.nick = unescape((cmd[4] as String).substr(2));
					b.CID = (cmd[5] as String).substr(2);
					b.groupIDs.push("Other Contacts");
					nse.buddy = new Array();
					nse.buddy.push(b);
					dispatchEvent(nse);
					break;
			}
		}
		private function exeREM(cmd:Array):void
		{
			var ek:String = trm.checkTR(parseInt(cmd[1]));
			if (ek == null)
				return;
			var ne:NotificationServerEvent = new NotificationServerEvent(ek);
			switch (ek)
			{
			case NotificationServerEvent.BUDDY_DEL:
				var b:Buddy = new Buddy();
				b.CID = cmd[3];
				ne.buddy = new Array();
				ne.buddy.push(b);
				break;
			case NotificationServerEvent.BUDDY_MOVE:
				break;
			case NotificationServerEvent.BUDDY_BLOCK:
				ne.user = (cmd[3] as String).substr(2);
				break;
			case NotificationServerEvent.BUDDY_UNBLOCK:
				ne.user = cmd[3];
				break;
			}
			dispatchEvent(ne);
		}
		private function exeADC(cmd:Array):void
		{
			var ek:String = trm.checkTR(parseInt(cmd[1]));
			if (ek == null)
				return;
			var ne:NotificationServerEvent = new NotificationServerEvent(ek);
			switch (ek)
			{
			case NotificationServerEvent.BUDDY_ADD:
				var b:Buddy = new Buddy();
				b.user = (cmd[3] as String).substr(2);
				b.nick = unescape((cmd[4] as String).substr(2));
				b.CID = (cmd[5] as String).substr(2);
				b.groupIDs.push("Other Contacts");
				ne.buddy = new Array();
				ne.buddy.push(b);
				break;
			case NotificationServerEvent.BUDDY_MOVE:
				break;
			case NotificationServerEvent.BUDDY_BLOCK:
				ne.user = (cmd[3] as String).substr(2);
				break;
			case NotificationServerEvent.BUDDY_UNBLOCK:
				ne.user = cmd[3];
				break;
			}
			dispatchEvent(ne);
		}
		private function exeREM2(cmd:Array):void
		{
			trace("REM - " + cmd.toString());
			var nse:NotificationServerEvent;
			var ek:String = trm.checkTR(parseInt(cmd[1]));
			switch(cmd[2])
			{
				case "BL":
					nse = new NotificationServerEvent(NotificationServerEvent.BUDDY_UNBLOCK);
					nse.user = cmd[3];
					dispatchEvent(nse);
					break;
				case "FL":
					nse = new NotificationServerEvent(NotificationServerEvent.BUDDY_DEL);
					var b:Buddy = new Buddy();
					b.CID = cmd[3];
					nse.buddy = new Array();
					nse.buddy.push(b);
					dispatchEvent(nse);
					break;
			}
		}
		private function exeREA(cmd:Array):void
		{
			trace("REA - " + cmd.toString());
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.RENAME);
			nse.user = cmd[3];
			nse.nick = cmd[4];
			dispatchEvent(nse);
		}
		private function exeADG(cmd:Array):void
		{
			trace("ADG - " + cmd.toString());
			var g:Group = new Group();
			g.name = unescape(cmd[2]);
			g.id = unescape(cmd[3]);
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.GROUP_ADD);
			nse.group = new Array();
			nse.group.push(g);
			dispatchEvent(nse);
		}
		private function exeREG(cmd:Array):void
		{
			trace("REG - " + cmd.toString());
		}
		private function exeRMG(cmd:Array):void
		{
			trace("RMG - " + cmd.toString());
			var nse:NotificationServerEvent = new NotificationServerEvent(NotificationServerEvent.GROUP_DEL);
			nse.group = new Array();
			nse.group.push(cmd[2]);
			dispatchEvent(nse);
		}
		private function exeUUX(msg:String):void
		{
			;
		}
		private function exeUBX(cmd:Array, lines:Array, offset:int):int
		{
			var bytes:int = parseInt(cmd[2]);
			if (bytes < 1)
				return 0;
			var dataTag:String;
			var jump:int = 0;
			var lastIdx:int = (lines[offset] as String).lastIndexOf("</Data>");
			if (lastIdx >= 0)
			{
				dataTag = lines[offset].substr(0,lastIdx+7);
				lines[offset] = lines[offset].substring(lastIdx+7);
			}
			else
			{
				lastIdx = (lines[offset+1] as String).indexOf("</Data>");
				dataTag = lines[offset] + lines[offset+1].substr(0,lastIdx+7);
				lines[offset+1] = lines[offset+1].substring(lastIdx+7);
				jump++;
			}
			trace("<DATA TAG>"+dataTag+"</DATATAG>");
			return jump;
		}
		private function exeRNG(cmd:Array):void
		{
			trace("RNG - " + cmd.toString());
			var ary:Array = cmd[2].split(":");
			var ip:String = ary[0];
			var port:int = parseInt(ary[1]);
			this.sbm.enterSession(ip , port, this.user, cmd[4], cmd[1]);
		}
		private function exeCHL(cmd:Array):void
		{
			trace("CHL - " + cmd.toString())
			var clg:Challenge = new Challenge();
			clg.addEventListener(Event.COMPLETE, exeCHLPong);
			clg.calcPing(cmd[2] as String);
			return;
		}
		private function exeCHLPong(e:Event):void
		{
			trace("CHL - PONG!");
			var c:Challenge = e.target as Challenge;
			send("QRY", c.getProductId() + " " + c.getPong().length + "\r\n" + c.getPong(), false);
		}
	}
}