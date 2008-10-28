package msnlib
{
	import flash.events.EventDispatcher;
//	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import mx.utils.StringUtil;
    import com.abdulqabiz.net.HTTPURLLoader;
	
	public class AuthenticationApollo extends EventDispatcher
	{
		public	var	ticket:String;
		
//		private var	url_stream:URLStream;
		private	var	url_request:URLRequest;
		private var url_loader:HTTPURLLoader;
		
		public function AuthenticationApollo():void
		{
			this.url_loader = new HTTPURLLoader();
			this.url_loader.addEventListener("complete", onCompleteHTTP);
			this.url_loader.addEventListener("httpStatus", onHttpStatusHTTP);
			this.url_loader.addEventListener("progress", onProgressHTTP);
		}

		private function onCompleteHTTP(event:Event):void
		{
	        var rh:Object = HTTPURLLoader(event.target)._header;
	
	        var str:String = "";
	
	        for(var p:String in rh)    str+= p + ":" + rh[p] + "\n";
	
	        trace("Response Headers: \n" + str + "\n");
	
	        //data property holds the content
	
	        trace("Body Content:\n" + HTTPURLLoader(event.target).data + "\n");
		}
		private function onHttpStatusHTTP(event:HTTPStatusEvent):void
		{
			trace("Event: httpStatus (" + event.status + ")\n");
		}
		private function onProgressHTTP(event:Event):void
		{
			;
		}

		public function requestTicket(user:String, pwd:String, challenge:String):void
		{
			var header:Array = new Array();
			header.push(new URLRequestHeader("Authorization","Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in="+user+",pwd="+pwd+","+challenge));
			header.push(new URLRequestHeader("User-Agent","MSMSGS"));
			header.push(new URLRequestHeader("Host","login.passport.com"));
			header.push(new URLRequestHeader("Connection","Keep-Alive"));
			header.push(new URLRequestHeader("Cache-Control","no-cache"));

			this.url_request = new URLRequest("https://login.passport.com/login2.srf");
			this.url_request.method = URLRequestMethod.GET;
			this.url_request.requestHeaders = header;

			this.url_loader.load(this.url_request);

/* 			this.url_stream = new URLStream();
			this.url_stream.addEventListener(Event.OPEN, onOpen);
			this.url_stream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.url_stream.addEventListener(Event.COMPLETE, onComplete);
			this.url_stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			this.url_stream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
			this.url_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			this.url_stream.load(this.url_request); */
		}
		private function onOpen(e:Event):void
		{
			trace("onOpen at AuthenticationApollo");
		}
		private function onProgress(e:ProgressEvent):void
		{
			trace("onProgress at AuthenticationApollo");
		}
		private function onComplete(e:Event):void
		{
			trace("onComplete at AuthenticationApollo");
		}
		private function onHttpStatus(e:HTTPStatusEvent):void
		{
			trace("onHttpStatus at AuthenticationApollo");
		}
		private function onHttpResponseStatus(e:HTTPStatusEvent):void
		{
			trace("onHttpResponseStatus at AuthenticationApollo");
		}
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("onSecurityError at AuthenticationApollo");
		}
	}
}