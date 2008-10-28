package com.mobsword.natelib.events {
	import com.mobsword.natelib.data.Message;
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class RadioEvent extends Event
	{
		public	static const OUTGOING_DATA	:String = 'outgoingData';
		public	static const INCOMING_DATA	:String = 'incomingData';

		public	var data:Message;

		/**
		 * 생성자
		 * @param	type	이벤트 타잎
		 * @param	d		이벤트 데이타
		 */
		public	function RadioEvent(type:String, d:Message)
		{
			super(type);
			data = d;
		}
	}
}

