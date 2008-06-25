package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Session;
	
	public class ConversationManager
	{
		public	var session:Session;
		
		public function ConversationManager(s:Session)
		{
			session = s;
			
			session.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
			session.addEventListener(RadioEvent.OUTGOING_DATA, onOutgoing);
		}

		private function onIncoming(event:RadioEvent):void
		{
			if (event.data.rid != 0)
				return;
			var from:String	= event.data.param[0] as String;
			var cmd:String	= event.data.param[1] as String;
			var data:String	= event.data.param[2] as String;
			
			switch (cmd)
			{
			case Command.TYPING:
				break;
			case Command.EMOTICON:
				break;
			case Command.MSG:
				break;
			}
		}
		
		private function onOutgoing(event:RadioEvent):void
		{
			;
		}
	}
}