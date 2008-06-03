package natelib
{
	import flash.net.Socket;
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	public class TransactionManager
	{
		/*
		* transaction database
		*/
		private var tr_log:ArrayCollection;
		private var tr_event:ArrayCollection;

		/*
		* Variables
		*/
		private	var	socket:Socket;
		private	var innerTrID:int;
		private var	outterTrID:int;
		private var executing:Boolean;

		public function TransactionManager(s:Socket):void
		{
			tr_log = new ArrayCollection(new Array());
			tr_event = new ArrayCollection(new Array());
			socket = s;
			innerTrID = 0;
			outterTrID = 0;
			executing = false;
		}

		public function beginTr(e:Event):void
		{
			executing = true;
			innerTrID++;
			tr_event.addItem([innerTrID, e]);
		}
		
		public function endTr():void
		{
			socket.flush();
			executing = false;
		}
		
		public function send(arg:Array, payload:Array = null):void
		{
			if (!socket.connected)
				return;
			outterTrID++;
			arg.splice(1,0,outterTrID.toString());
			var cmd_str:String = arg.join(" ");
			if (payload != null)
			{
				var pl_buffer:String = payload.join(" ");
				cmd_str += " " + pl_buffer.length.toString() + "\r\n" + pl_buffer;
			}
			else
				cmd_str += "\r\n";
			trace("COMMAND_STRING@TransactionManager:\t"+StringUtil.trim(cmd_str));
			socket.writeUTFBytes(cmd_str);
			socket.flush();
			if (executing)
				tr_log.addItem([innerTrID, outterTrID]);
		}

		public function attachValue(oid:int, v:Array):void
		{
			var item:Array;
			var iid:int;
			var ne:NateEvent;
			for each(item in tr_log)
			{
				if (item[1] == oid)
				{
					iid = item[0];
					break;
				}
			}
			
			for each(item in tr_event)
			{
				if (item[0] == iid)
				{
					ne = item[1] as NateEvent;
					ne.value = v;
					break;
				}
			}
		}

		public function getValue(oid:int):Array
		{
			var item:Array;
			var iid:int;
			for each(item in tr_log)
			{
				if (item[1] == oid)
				{
					iid = item[0];
					break;
				}
			}
			
			for each(item in tr_event)
			{
				if (item[0] == iid)
					return (item[1] as NateEvent).value;
			}
			return null
		}

		public function hasEvent(oid:int):Event
		{
			var item:Array = null;
			var iid:int = -1;		//innerTrID
			var endTR:Boolean = true;

			for each(item in tr_log.source)
			{
				if (item[1] == oid)
				{
					iid = item[0];
					tr_log.removeItemAt(tr_log.getItemIndex(item));
					break;
				}
			}
			
			for each(item in tr_log.source)
			{
				if (item[0] == iid)
				{
					endTR = false;
					break;
				}
			}
			
			if (!endTR)					//NOT processed work exist
				return null;
			
			for each(item in tr_event.source)
			{
				if (item[0] == iid)
				{
					tr_event.removeItemAt(tr_event.getItemIndex(item));
					return item[1] as Event;
				}
			}
//			trace("HASEVENT@TransactionManager: Inner Transaction not found");
			return null;
		}
	}
}