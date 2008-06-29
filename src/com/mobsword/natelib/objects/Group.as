package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.data.GroupData;
	import com.mobsword.natelib.events.RadioEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	* ...
	* @author Default
	*/
	[Event(name = "g_renameGroup", type = "com.mobsword.natelib.events.GroupEvent")]
	[Event(name = "g_removeGroup", type = "com.mobsword.natelib.events.GroupEvent")]
	public class Group extends EventDispatcher
	{
		public	var data:GroupData;
		
		public	function Group(gd:GroupData)
		{
			data = gd;
		}
		
		public	function remove():void
		{
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, data.account.mm.genRMVG(data.id)), true);
		}
		
		public	function rename(name:String):void
		{
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, data.account.mm.genRENG(data.id, name)), true);
		}
	}
}

