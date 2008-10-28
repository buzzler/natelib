package natelib
{
	import flash.net.Socket;
	import mx.utils.StringUtil;
	
	public class SessionSender
	{
		private var socket:Socket;
		private var trID:int;

		public function SessionSender(s:Socket):void
		{
			socket = s;
			trID = 0;
		}
		
		public function send(arg:Array):void
		{
			trID++;
			arg.splice(1,0,trID.toString());
			var cmd_str:String = arg.join(" ")+"\r\n";
			trace("COMMAND_STRING@SessionSender:\t\t"+StringUtil.trim(cmd_str));
			socket.writeUTFBytes(cmd_str);
			socket.flush();
		}
	}
}