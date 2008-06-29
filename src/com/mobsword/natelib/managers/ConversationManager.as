package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.events.MessageEvent;
	import com.mobsword.natelib.events.RadioEvent;
	import com.mobsword.natelib.objects.Session;
	import com.mobsword.natelib.utils.Codec;
	
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
			var me:MessageEvent;
			switch (cmd)
			{
			case Command.TYPING:
				me = new MessageEvent(MessageEvent.TYPING);
				me.typing = data;
				break;
			case Command.EMOTICON:
				return;
			case Command.MSG:
				var param:Array = data.split('%09');
				me = new MessageEvent(MessageEvent.MESSAGE);
				me.font		= Codec.decode(param[0] as String);
				me.color	= param[1] as String;
				me.fonttype	= param[2] as String;
				me.message	= Codec.decode(param[3] as String);
				break;
			}
			session.dispatchEvent(me);
		}
		
		private function onOutgoing(event:RadioEvent):void
		{
			;
		}
	}
}