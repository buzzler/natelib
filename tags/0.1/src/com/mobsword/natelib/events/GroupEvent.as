package com.mobsword.natelib.events
{
	import com.mobsword.natelib.objects.Group;
	
	import flash.events.Event;

	public class GroupEvent extends Event
	{
		public	static const NEW_GROUP		:String = 'g_newGroup';
		public	static const RENAME_GROUP	:String = 'g_renameGroup';
		public	static const REMOVE_GROUP	:String = 'g_removeGroup';
		
		public	var group		:Group;
		public	var old_value	:String;
		public	var new_value	:String;
		
		public function GroupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}