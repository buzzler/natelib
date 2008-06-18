package com.mobsword.natelib.objects
{
	import com.mobsword.natelib.data.GroupData;
	import com.mobsword.natelib.events.RadioEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class Group
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

