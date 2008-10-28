package natelib
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.HTTPService;
	import flash.net.URLLoader;
	import mx.utils.XMLUtil;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import mx.rpc.events.ResultEvent;

	public class Sms extends EventDispatcher
	{
		/*
		* Account Info
		*/
		private var data:DataStorage;
		
		/*
		* System Variables
		*/
		public	var	sms_data:SmsDataStorage;
		private var loader:URLLoader;
		private var request:URLRequest;
		private var step:int;
		public	var isReady:Boolean;
		private var queue_message:Array;
				
		public function Sms(account:Account):void
		{
			this.data = account.data;
			
			this.sms_data = new SmsDataStorage();
			this.loader = new URLLoader();
			this.loader.addEventListener(Event.COMPLETE, onComplete);
			this.request = new URLRequest();
			this.step = 0;
			this.isReady = false;
			this.queue_message = new Array();
		}
		
		private function onComplete(event:Event):void
		{
			trace(step);
			switch(step)
			{
			case 1:
				exe1st(loader.data);
				break;
			case 2:
				exe2nd(loader.data);
				break;
			case 3:
				exe3rd(loader.data);
				break;
			case 4:
				this.isReady = true;
				dispatchEvent(new Event(Event.CONNECT));
				break;
			case 5:
				exe5th(loader.data);
				break;
			case 6:
				exe6th(loader.data);
				break;
			}
		}
		
		public function connect():void
		{
			this.step = 1;
			var body:String = "t=" + data.tickets[1];
			body += "&code=G009&param=%3fTICKET%3d" + data.tickets[1];
			body += "%26ID%3d" + data.email;
			body += "%26mobile%3d";
			request.url = "http://br.nate.com/index.php";
			request.contentType = 'application/x-www-form-urlencoded';
			request.data = body;
			request.manageCookies = true;
			request.method = URLRequestMethod.POST;
			request.useCache = false;
			request.userAgent = 'Mozilla/4.0 (compatible; MSIE 6.0; windows NT 5.1; SV1; .NET CLR 2.0.50727; .NET CLR 1.1.4322)';
			
			loader.load(request);
		}
		
		private function dateToString(date:Date):String
		{
			var fixer:Function = function(str:String, digit:int):String {
				if (str.length >= digit)
					return str;
				var result:String = str;
				while (result.length < digit)
				{
					result = "0" + result;
				}
				return result;
			};
			var rsvdate:String = "";
			rsvdate += fixer(date.getFullYear().toString(), 4);
			rsvdate += fixer(date.getMonth().toString(), 2);
			rsvdate += fixer(date.getDay().toString(), 2);
			rsvdate += fixer(date.getHours().toString(), 2);
			rsvdate += fixer(date.getMinutes().toString(), 2);
			return rsvdate;
		}
		
		private function getBytes(str:String):int
		{
			var i:int;
			var sum:int = 0;
			var c:Number;
			for (i = 0 ; i < str.length ; i++)
			{
				c = str.charCodeAt(i);
				if (c < 0x0080)
					sum += 1;
				else
					sum += 2;
			}
			return sum;
		}
		
		private function indexOfPage(str:String):int
		{
			var i:int;
			var sum:int = 0;
			var c:Number;
			for (i = 0 ; i < str.length ; i++)
			{
				c = str.charCodeAt(i);
				if (c < 0x0080)
					sum += 1;
				else
					sum += 2;
				if (sum == 80)
					return i+1;
				else if (sum > 80)
					return i;
			}
			return str.length;
		}
		
		private function slicer(str:String):Array
		{
			var result:Array = new Array();
			var buffer:String = str;
			var i:int;
/* 			var sum:int = 0;
			var c:Number;
			for (i = 0 ; i < str.length ; i++)
			{
				c = str.charCodeAt(i);
				if (c < 0x0080)
					sum += 1;
				else
					sum += 2;
			}
			return sum; */
			do
			{
				i = indexOfPage(buffer);
				result.push(buffer.substring(0, i));
				buffer = buffer.substring(i);
			} while(buffer.length > 0);
			return result
		}
		
		public function send(msg:String, recvNumber:String, sendNumber:String = null, date:Date = null):void
		{
			recvNumber = recvNumber.replace(/ /g, '');
			recvNumber = recvNumber.replace(/a-z/g, '');
			recvNumber = recvNumber.replace(/A-Z/g, '');
			if (sendNumber == null)
				sendNumber = data.mobile;
			if (sendNumber.length < 1)
				sendNumber = data.mobile;
			var rsvdate:String = "";
			if (date != null)
			{
				rsvdate = dateToString(date);
			}
			else
				rsvdate = "000000000000";
				
			var msgs:Array = slicer(msg);
			for each(var m:String in msgs)
			{
				this.queue_message.push([m, recvNumber, sendNumber, rsvdate]);
			}
				
			processQueue();
		}
		
		private function processQueue():void
		{
			if (this.queue_message.length < 1)
				return;
			this.step = 5;
			var uri:String;
			uri = "/servlets/NateonSparrow?receivenum="+this.queue_message[0][1];
			uri+= "&receivename=%20&v_message="+escape(this.queue_message[0][0]);
			uri+= "&sendnum="+this.queue_message[0][2];
			uri+= "&rsvdate="+this.queue_message[0][3]+"&display=MMS&notFree=false&gi_id=&gi_cnt=";
			
			request.method = URLRequestMethod.POST;
			request.url = "http://sms.nate.com" + uri;
			request.data = "msg=&isFirst=first";

			loader.load(request);
			this.queue_message.splice(0,1);
		}
		
		private function exe1st(data:Object):void
		{
			this.step = 2;
			var tmpData:String = data.toString();
			var uri:String = tmpData.substring(tmpData.indexOf('http://'), tmpData.indexOf("';\""));
			request.method = URLRequestMethod.GET;
			request.url = uri;
			request.data = null;
			
			loader.load(request);
		}
		
		private function exe2nd(data:Object):void
		{
			this.step = 3;
			var tmpData:String = data.toString();
			var start:int = tmpData.lastIndexOf('<form');
			var end:int = tmpData.indexOf('/form>', start) + 6;
			tmpData = tmpData.substring(start, end);
			tmpData = tmpData.replace(/">/g, '"/>');
			
			var action:String;
			start	= tmpData.indexOf('action="')+8;
			end		= tmpData.indexOf('"', start);
			action	= tmpData.substring(start, end);
			tmpData	= tmpData.substring(end);
			
			var method:String;
			start	= tmpData.indexOf('method=') + 7;
			end		= tmpData.indexOf(' ', start);
			method	= tmpData.substring(start, end).toUpperCase();
			tmpData	= tmpData.substring(end);
			
			var key:String;
			var value:String;
			var params:Array = new Array();
			start	= tmpData.indexOf('hidden name=')+12;
			while (start > 11)
			{
				end	= tmpData.indexOf(' ', start);
				key	= tmpData.substring(start, end);
				tmpData = tmpData.substring(end);
				start=tmpData.indexOf('value="')+7;
				end	= tmpData.indexOf('"', start);
				value=tmpData.substring(start, end);
				tmpData = tmpData.substring(end);
				
				if (key == 'freeCnt')
					this.sms_data.freeCount = parseInt(value);
				if (key == 'fplusCnt')
					this.sms_data.freePlusCount = parseInt(value);
				if (key == 'fplus100')
					this.sms_data.freePlus100Count = parseInt(value);
				if (key == 'fplus500')
					this.sms_data.freePlus500Count = parseInt(value);
				
				params.push(key + "=" + value);
				
				start=tmpData.indexOf('hidden name=')+12;
			}
			
			request.method = method;
			request.url = 'http://sms.nate.com' + action;
			request.data = params.join('&');

			loader.load(request);
		}
		
		private function exe3rd(data:Object):void
		{
			this.step = 4;
			var tmpData:String = data.toString();
			var start:int = tmpData.lastIndexOf("<form name='smsForm'");
			var end:int = tmpData.indexOf('/form>', start) + 6;
			tmpData = tmpData.substring(start, end);
			tmpData = tmpData.replace(/">/g, '"/>');
			
			var method:String;
			start	= tmpData.indexOf("method='") + 8;
			end		= tmpData.indexOf("'", start);
			method	= tmpData.substring(start, end).toUpperCase();
			tmpData	= tmpData.substring(end);
			
			var action:String;
			start	= tmpData.indexOf("action='")+8;
			end		= tmpData.indexOf("'", start);
			action	= tmpData.substring(start, end);
			tmpData	= tmpData.substring(end);
			
			
			var key:String;
			var value:String;
			var params:Array = new Array();
			start	= tmpData.indexOf('hidden name=')+12;
			while (start > 11)
			{
				end	= tmpData.indexOf(' ', start);
				key	= tmpData.substring(start, end);
				tmpData = tmpData.substring(end);
				start=tmpData.indexOf("value='")+7;
				end	= tmpData.indexOf("'", start);
				value=tmpData.substring(start, end);
				tmpData = tmpData.substring(end);
				
				params.push(key + "=" + value);
				
				start=tmpData.indexOf('hidden name=')+12;
			}
			
			request.method = method;
			request.url = 'http://sms.nate.com/nateon_tui/' + action;
			request.data = params.join('&');
			
			loader.load(request);
		}
		
		private function exe5th(data:Object):void
		{
			if (this.queue_message.length > 0)
			{
				processQueue();
				return;
			}
			this.step = 6;
			var tmpData:String = data.toString();
			var start:int = tmpData.indexOf("window.open('") + 13;
			var end:int = tmpData.indexOf("'", start);
			var uri:String = tmpData.substring(start, end);
			
			request.method = URLRequestMethod.GET;
			request.url = "http://sms.nate.com" + uri;
			request.data = null;
			
			loader.load(request);
		}
		
		private function exe6th(data:Object):void
		{
			this.step = 7;
			var tmpData:String = data.toString();
			var start:int = tmpData.indexOf('<td><span class="PopOrn">')+25;
			var end:int = tmpData.indexOf('</span>', start);
			var left:int = parseInt(tmpData.substring(start, end));
			
			start = tmpData.lastIndexOf('<td class="Non">', start)+16;
			end = tmpData.indexOf('</td>', start);
			var used:int = parseInt(tmpData.substring(start,end));
			
			var result:Object = new Object();
			result["used"] = used;
			result["left"] = left;
			dispatchEvent(new ResultEvent(ResultEvent.RESULT, false, true, result));
		}
	}
}