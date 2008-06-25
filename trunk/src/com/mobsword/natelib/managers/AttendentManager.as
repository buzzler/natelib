package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Attendent;
	import com.mobsword.natelib.objects.Session;
	import com.mobsword.natelib.utils.Codec;
	
	public class AttendentManager
	{
		public	var session:Session;
		public	var numAttendies:int;
		public	var all:Object;
		public	var attendies:Array;
		
		public function AttendentManager(s:Session)
		{
			session		= s;
			numAttendies= 0;
			all			= new Object();
			attendies	= new Array();
			
			session.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
		}

		private function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.USER:
				onUSER(event.data);
				break;
			case Command.QUIT:
				onQUIT(event.data);
				break;
			case Command.JOIN:
				onJOIN(event.data);
				break;
			case Command.WHSP:
				onWHSP(event.data);
				break;
			}
		}
		
		private function onUSER(m:Message):void
		{
			var a:Attendent = new Attendent();
			a.email	= m.param[2] as String;
			a.nick	= Codec.decode(m.param[3] as String);
			a.name	= Codec.decode(m.param[4] as String);
			a.friend= session.account.fm.getFriendByEmail(a.email);
			
			attendies.push(a);
			all[a.email] = a;
			numAttendies++;
		}
		
		private function onQUIT(m:Message):void
		{
			if (m.rid == 0)		//quit attendent
			{
				var email:String = m.param[0] as String;
				var a:Attendent = all[email] as Attendent;
				if (a != null)
				{
					attendies.splice(attendies.indexOf(a),1);
					all[email] = null;
					numAttendies--;
				}
			}
			else				//quit self
			{
				attendies.length = 0;
				all = new Object();
				numAttendies = 0;
			}
		}
		
		private function onJOIN(m:Message):void
		{
			var a:Attendent = new Attendent();
			a.email	= m.param[0] as String;
			a.nick	= Codec.decode(m.param[1] as String);
			a.name	= Codec.decode(m.param[2] as String);
			a.friend= session.account.fm.getFriendByEmail(a.email);
			
			attendies.push(a);
			all[a.email] = a;
			numAttendies++;
		}
		
		private function onWHSP(m:Message):void
		{
			var email:String= m.param[0] as String;
			var cmd:String	= m.param[1] as String;
			var data:String	= m.param[2] as String;
			var a:Attendent = all[email] as Attendent;
			if (a != null)
			{
				switch (cmd)
				{
				case Command.AVCHAT2:
					a.avchat = data;
					break;
				case Command.FONT:
					a.font = data;
					break;
				case Command.DPIMG:
					a.dpimg = data;
					break;
				}
			}
		}
	}
}

