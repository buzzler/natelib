package msnlib
{
	import flash.events.Event;
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import mx.utils.StringUtil;

	public class Switchboard extends EventDispatcher
	{
		private var connection:Socket;
		private var user:String;
		private var ip:String;
		private var port:int;
		private var auth:String;
		public	var sid:String;
		public	var temp:String;
		private var trid:int;
		public	var participants_nick:Array;
		public	var participants_user:Array;
		
		public	var	suicide:Function;

		
		public function Switchboard(ip:String, port:int):void
		{
			this.ip = ip;
			this.port = port;
			trid = 0;
			this.participants_nick = new Array();
			this.participants_user = new Array();
			connection = new Socket();
			connection.addEventListener(ProgressEvent.SOCKET_DATA, dataListener);
			connection.addEventListener(Event.CLOSE, onClose);
			connection.connect(this.ip, this.port);
		}
		
		private function send(cmd:String, param:String = null):void
		{
			if (param != null)
				connection.writeUTFBytes(cmd + " " + trid.toString() + " " + param + "\r\n");
			else
				connection.writeUTFBytes(cmd + "\r\n");
			connection.flush();
			trid++;
		}
		
		private function sendNoneNewLine(cmd:String, param:String = null):void
		{
			if (param != null)
				connection.writeUTFBytes(cmd + " " + trid.toString() + " " + param);
			else
				connection.writeUTFBytes(cmd);
			connection.flush();
			trid++;
		}
		
		public function newSession(user:String, auth:String, buddy:String):void
		{
			this.user = user;
			this.auth = auth;
			this.temp = buddy;
			send("USR", user + " " + auth);
		}
		public function enterSession(user:String, auth:String, sid:String):void
		{
			this.user = user;
			this.auth = auth;
			this.sid = sid;
			send("ANS", this.user + " " + this.auth + " " + this.sid);
		}
		
		public function quitSession():void
		{
			if (this.connection.connected)
			{
				send("OUT");
			}
		}
		
		public function talkSession(msg:String):void
		{
			var mime:String = "MIME-Version: 1.0\r\n";
			mime += "Content-Type: text/plain; charset=UTF-8\r\n";
			mime += "X-MMS-IM-Format: FN=Arial; EF=; CO=0; CS=0; PF=22\r\n\r\n";
			mime += msg;
			mime = "U " + getBytes(mime) + "\r\n" + mime;
			sendNoneNewLine("MSG", mime);
		}
		private function getBytes(str:String):int
		{
			var i:int;
			var sum:int = 0;
			var c:Number;
			for (i = 0 ; i < str.length ; i++)
			{
				c = str.charCodeAt(i);
				if (c < 0x0080)
					sum += 1;
				else if (c >= 0x0800)
					sum += 3;
				else if ((c >= 0x0080)&&(c < 0x0800))
					sum += 2;
			}
			return sum;
		}
		private function getEndOfIndex(str:String, bytes:int):int
		{
			var i:int;
			var sum:int = 0;
			var c:Number;
			for (i = 0 ; i < str.length ; i++)
			{
				c = str.charCodeAt(i);
				if (c < 0x0080)
					sum += 1;
				else if (c >= 0x0800)
					sum += 3;
				else if ((c >= 0x0080)&&(c < 0x0800))
					sum += 2;
				if (sum == bytes)
					return i;
			}
			return -1;
		}
		private function dataListener(event:ProgressEvent):void
		{
			var i:int = 0;
			var length:int = connection.bytesAvailable;
			var totalMIME:String = connection.readMultiByte(length, "utf-8");
			var lines:Array = totalMIME.split("\n");
			while(i < lines.length)
			{
				var cmd:Array = StringUtil.trim(lines[i]).split(" ");
				switch (cmd[0])
				{
					case "IRO":
						exeIRO(cmd);
						break;
					case "ANS":
						exeANS(cmd);
						break;
					case "USR":
						exeUSR(cmd);
						break;
					case "CAL":
						exeCAL(cmd);
						break;
					case "JOI":
						exeJOI(cmd);
						break;
					case "BYE":
						exeBYE(cmd);
						break;
					case "ACK":
						break;
					case "NAK":
						break;
					case "MSG":
//						i += exeMSG(lines.slice(i+1).join("\r\n").substr(0, cmd[3]), cmd[1], cmd[2]);
						totalMIME = exeMSG(totalMIME, cmd[1], cmd[2], cmd[3]);
						lines = totalMIME.split("\n");
						i = -1;
						break;
					default:
						break;
				}
				i++;
			}
		}

		private function onClose(event:Event):void
		{
			trace("DISCONNECT SESSION Socket");
			this.quitSession();
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.DISCONNECT);
			sbe.sid = this.sid;
			dispatchEvent(sbe);
		}
		public function finalize():void
		{
			this.onClose(null);
		}
		private function exeIRO(cmd:Array):void
		{
			this.participants_user.push(unescape(cmd[4]));
			this.participants_nick.push(unescape(cmd[5]));
			if (cmd[2] == cmd[3])
			{
				var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.INITIALROASTER);
				dispatchEvent(sbe);
			}
		}
		private function exeANS(cmd:Array):void
		{
			if (cmd[2] == "OK")
			{
				var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.ANSWER);
				dispatchEvent(sbe);
			}
		}
		private function exeMSG(mime:String, user:String, nick:String, payload:int):String
		{
			user = unescape(user);
			nick = unescape(nick);
			var total:String = mime.substr(mime.indexOf("\r\n")+2);
			var i:int = getEndOfIndex(total, payload);
			var m:String = total.substring(0, i+1);
			var trash:String = total.substr(i+1);
			
			i = m.indexOf("\r\n\r\n");
			var head:Array = m.substr(0, i).split("\n");
			var body:String = m.substr(i+4);
			
			var sbe:SwitchboardEvent;
			for each(var el:String in head)
			{
				switch (el.substring(0,el.indexOf(": ")))
				{
				case "Content-Type":
					switch (el.substring(el.indexOf("/")+1,el.indexOf(";")))
					{
					case SwitchboardEvent.CONTROL:
						sbe = new SwitchboardEvent(SwitchboardEvent.CONTROL);
						break;
					case SwitchboardEvent.DATA:
						sbe = new SwitchboardEvent(SwitchboardEvent.DATA);
						break;
					case SwitchboardEvent.EMOTICON:
						sbe = new SwitchboardEvent(SwitchboardEvent.EMOTICON);
						break;
					case "plain":
						sbe = new SwitchboardEvent(SwitchboardEvent.MESSAGE);
						sbe.message = body;
						break;
					}
					break;
				case "X-MMS-IM-Format":
					for each(var stl:String in el.substr(el.indexOf(": ")+2).split("; "))
					{
						if (stl.length < 4) continue;
						switch(stl.substr(0,2))
						{
						case "FN":
							break;
						case "EF":
							break;
						case "CO":
							sbe.color = "#"+stl.substr(3);
							break;
						case "CS":
							break;
						case "PF":
							break;
						}
					}
					break;
				}
			}
			updateRoaster(user, nick);
			if (sbe != null)
			{
				sbe.sid = this.sid;
				sbe.roaster_nick.push(nick);
				sbe.roaster_user.push(user);
				dispatchEvent(sbe);
			}
			return trash;
		}
		private function exeMSG2(mime:String, user:String, nick:String):int
		{
			var buffer:String;
			var ary:Array = mime.split("\r\n");
			var cmd:Array;
			var tmp:String;
			var offset:int = ary.length;
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.MESSAGE);
			var i:int;
			for (i = 0 ; i < ary.length ; i ++)
			{
				if (ary[i].length < 1)
					break;
				cmd = ary[i].split(": ");
				if (cmd[0] == "Content-Type")
				{
					tmp = cmd[1].substring(cmd[i].indexOf("/")+1);
					switch (tmp)
					{
						case SwitchboardEvent.CONTROL:
							sbe = new SwitchboardEvent(SwitchboardEvent.CONTROL);
							sbe.sid = this.sid;
							sbe.roaster_user.push(user);
							sbe.roaster_nick.push(nick);
							dispatchEvent(sbe);
							return offset;
						case SwitchboardEvent.DATA:
							dispatchEvent(new SwitchboardEvent(SwitchboardEvent.DATA));
							return offset;
						case SwitchboardEvent.EMOTICON:
							dispatchEvent(new SwitchboardEvent(SwitchboardEvent.EMOTICON));
							return offset;
						default:
							break;
					}
				}
				else if (cmd[0] == "X-MMS-IM-Format")
				{
					var form:Array = (cmd[1] as String).split("; ");
					for each(var formStr:String in form)
					{
						if (formStr.length < 4) continue;
						switch(formStr.substr(0,2))
						{
						case "FN":
							break;
						case "EF":
							break;
						case "CO":
							sbe.color = "#"+formStr.substr(3);
							break;
						case "CS":
							break;
						case "PF":
							break;
						}
					}
				}
			}
			buffer = ary.slice(i+1).join("\r\n");
			updateRoaster(unescape(user), unescape(nick));
			sbe.sid = this.sid;
			sbe.message = unescape(buffer);
			sbe.roaster_user.push(unescape(user));
			sbe.roaster_nick.push(unescape(nick));
			dispatchEvent(sbe);
			return offset;
		}
		private function updateRoaster(user:String, nick:String):void
		{
			this.participants_nick[getIndex(user)] = nick;
		}
		private function exeBYE(cmd:Array):void
		{
			var i:int = getIndex(cmd[1]);
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.BYE);
			sbe.sid = this.sid;
			sbe.roaster_user.push(this.participants_user[i]);
			sbe.roaster_nick.push(this.participants_nick[i]);
			this.participants_nick.splice(i,1);
			this.participants_user.splice(i,1);
			dispatchEvent(sbe);
		}
		private function getIndex(user:String):int
		{
			var i:int;
			for (i = 0 ; i < this.participants_user.length ; i++)
			{
				if (this.participants_user[i] == user)
					return  i;
			}
			return -1;
		}
		private function exeJOI(cmd:Array):void
		{
			cmd[1] = unescape(cmd[1]);
			cmd[2] = unescape(cmd[2]);
			this.participants_user.push(cmd[1]);
			this.participants_nick.push(cmd[2]);
			var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.JOIN);
			sbe.sid = this.sid;
			sbe.roaster_nick = this.participants_nick;
			sbe.roaster_user = this.participants_user;
			dispatchEvent(sbe);
		}
		private function exeUSR(cmd:Array):void
		{
			if (cmd[2] == "OK")
			{
				inviteBuddy(this.temp);
			}
		}
		private function exeCAL(cmd:Array):void
		{
			if (cmd[2] == "RINGING")
			{
				this.sid = cmd[3];
				var sbe:SwitchboardEvent = new SwitchboardEvent(SwitchboardEvent.CALLING);
				sbe.sid = this.sid;
				dispatchEvent(sbe);
			}
		}
		public function inviteBuddy(user:String):void
		{
			send("CAL", user);
		}
	}
}