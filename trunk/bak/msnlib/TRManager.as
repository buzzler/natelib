package msnlib
{
	public class TRManager
	{
		private var event:Array;
		private var queue:Array;
		private var command:Array;
		private var index:int;
		private var name:String;

		public function TRManager():void
		{
			event = new Array();
			queue = new Array();
//			commend = new Array();
		}
		public function startTR(name:String):void
		{
			event.push(name);
			queue.push(new Array());
//			command.push(new Array());
			index = queue.length -1;
		}
		public function addTR(trid:int):void
		{
			queue[index].push(trid);
		}
		public function checkTR(trid:int):String
		{
			var i:int;
			var j:int;
			var e:String;
			for (i = 0 ; i < queue.length ; i++)
				for (j = 0 ; j < queue[i].length ; j++)
					if (queue[i][j] == trid)
					{
						queue[i].splice(j,1);
						if (queue[i].length == 0)
						{
							name = event[i];
							event.splice(i, 1);
							queue.splice(i, 1);
							return name;
						}
						return null;
					}
			return null;
		}
	}
}