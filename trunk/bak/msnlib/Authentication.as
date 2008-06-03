package msnlib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.HTML;
	import mx.utils.StringUtil;

	public class Authentication extends EventDispatcher
	{
		private var uri:String = "https://login.passport.com/login2.srf";
		private var usr:String;
		private var pwd:String;
		private var clg:String;
		private var html:HTML;
		public var	ticket:String;

		private var htmlString:String =
		"<html>"
		+"<script type='text/javascript'>"
		+"var LOADED=4;"
		+"var STATUS_OK=200;"
		+"var STATUS_FOUND=302;"
		+"var STATUS_UNAUTHORIZED=401;"
		+"var client=null;"
		+"function createXmlRequest()"
		+"{"
		+"	if( window.XMLHttpRequest )"
		+"		return new XMLHttpRequest();"
		+"	else"
		+"	if( window.ActiveXObject )"
		+"		return new ActiveXObject('Microsoft.XMLHTTP');"
		+"	return null;"
		+"}"
		+"function reqHeader(uri,host,usr,pwd,clg)"
		+"{"
		+"	client = createXmlRequest();"
		+"	client.open('GET', uri,true);"
		+"	client.setRequestHeader('Authorization','Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in='+usr+',pwd='+pwd+','+clg);"
		+"	client.setRequestHeader('Host',host);"
		+"}"
		+"function send()"
		+"{"
		+"	client.send(null);"
		+"}"
		+"</script>"
		+"<body>"
		+"</body>"
		+"</html>";

		public function Authentication():void
		{
			html		= new HTML();
			ticket		= null;
			html.addEventListener(Event.COMPLETE, completeHandler);
		}
		public function requestTicket(user:String, password:String, challenge:String):void
		{
			usr			= user;
			pwd			= password;
			clg			= challenge;
			html.htmlLoader.loadString(this.htmlString);
		}
		private function getHost(url:String):String
		{
			var result:Array = StringUtil.trim(url).split("/");
			return result[2];
		}
		private function completeHandler(event:Event):void
		{
 			html.htmlLoader.window.reqHeader(uri,getHost(uri),usr,pwd,clg);
			html.htmlLoader.window.client.onreadystatechange=onReadyStateChange;
			html.htmlLoader.window.send();
		}
		private function onReadyStateChange(event:Object):void
		{
			if( html.htmlLoader.window.client.readyState==html.htmlLoader.window.LOADED)
			{
				switch (html.htmlLoader.window.client.status)
				{
					case html.htmlLoader.window.STATUS_OK:
						var auth_info:String = html.htmlLoader.window.client.getResponseHeader("Authentication-Info");
						ticket = auth_info.substring(auth_info.search("from-PP=")+9,auth_info.length-1);
						ticket = ticket.substring(0, ticket.indexOf(",")-1);
						dispatchEvent(new AuthenticationEvent(AuthenticationEvent.TICKET));
						break;
					case html.htmlLoader.window.STATUS_FOUND:
						uri = html.htmlLoader.window.client.getResponseHeader("Location");
						html.htmlLoader.window.reqHeader(uri,getHost(uri),usr,pwd);
						html.htmlLoader.window.send();
						dispatchEvent(new AuthenticationEvent(AuthenticationEvent.REDIRECTION));
						break;
					case html.htmlLoader.window.STATUS_UNAUTHORIZED:
						dispatchEvent(new AuthenticationEvent(AuthenticationEvent.UNAUTHORIZED));
						break;
				}
			}
		}
	}
}