package natelib
{
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class Account extends EventDispatcher
	{
		/*
		* Data
		*/
		public var data:DataStorage;
		
		/*
		* Variables
		*/
		private var client:Client;
		private var sm:SessionManager;
		public	var sms:Sms;
		
		public function Account():void
		{
			data = new DataStorage();
			client = new Client(this);
			sm = new SessionManager(this);
			sms = new Sms(this);
			client.addEventListener(Event.CLOSE, onClose);
			client.addEventListener(NateEvent.ERROR_SIGNIN, onError);
			client.addEventListener(NateEvent.ACCOUNT_STATE, onAccountState);
			client.addEventListener(NateEvent.ACCOUNT_UPDATE, onAccountUpdate);
			client.addEventListener(NateEvent.AUTHENTICATION, onAuthentication);
			client.addEventListener(NateEvent.BUDDY_STATE, onBuddyState);
			client.addEventListener(NateEvent.BUDDY_UPDATE, onBuddyUpdate);
			client.addEventListener(NateEvent.GETTING_DETAIL, onGettingDetail);
			client.addEventListener(NateEvent.GROUP_UPDATE, onGroupUpdate);
			client.addEventListener(NateEvent.KILLED, onKilled);
			client.addEventListener(NateEvent.REDIRECTION, onRedirection);
			client.addEventListener(NateEvent.SESSION_CLOSE, onSessionClose);
			client.addEventListener(NateEvent.SESSION_OPEN, onSessionOpen);
			client.addEventListener(NateEvent.SESSION_REQUEST, onSessionRequest);
			client.addEventListener(NateEvent.SESSION_INVITE, onSessionInvite);
			client.addEventListener(NateEvent.SESSION_SHORT_MSG, onShortMessage);
		}
		
		public function signin(u:String, p:String, s:String):void
		{
			data.email = u;
			data.pwd = p;
			data.status = s;
			if ((u == null)&&(p == null))
				return;

			client.connect(Constants.NATEON_HOST_IP, Constants.NATEON_HOST_PORT);
		}
		
		public function signout():void
		{
			sm.removeSessionAll();
			client.disconnect();
		}
		
		public function getting_detail():void
		{
			client.getting_details_step1();
		}
		
		public function conversation(contact:String):void
		{
			client.requestSS(contact);
		}
		
		public function invitation(email:String, session:Session):void
		{
			client.inviteSS(email, session.session_data.ip, session.session_data.port, session.session_data.key);
		}
		
		public function whisper(email:String, msg:String):void
		{
			client.shortMessage(email, msg);
		}
		
		public function account_rename(name:String):void
		{
			client.account_rename(name);
		}
		
		public function account_state(status:String):void
		{
			client.account_state(status);
		}
		
		public function buddy_add(email:String, gid:String = '0', msg:String = 'welcome'):void
		{
				client.buddy_add(email, gid, msg);
		}
		
		public function buddy_remove(email:String):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
					break;
			}
			client.buddy_remove(x.@gid, x.@email);
		}
		
		public function buddy_block(email:String):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
					break;
			}
			client.buddy_block(x.@id, x.@email);
		}
		
		public function buddy_unblock(email:String):void
		{
			for each(var x:XML in data.buddies)
			{
				if (x.@email == email)
					break;
			}
			client.buddy_unblock(x.@id, x.@email);
		}
		
		public function group_add(name:String):void
		{
			client.group_add(name);
		}
		
		public function group_remove(gid:String):void
		{
			client.group_remove(gid);
		}
		
		public function group_rename(gid:String, name:String):void
		{
			client.group_rename(gid, name);
		}
		
		private function cloneEvent(event:NateEvent):void
		{
			var ne:NateEvent = new NateEvent(event.type);
			ne.value = event.value;
			dispatchEvent(ne);
		}
		private function onClose(event:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		private function onError(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onAccountState(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onAccountUpdate(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onAuthentication(event:NateEvent):void
		{;
			cloneEvent(event);
		}
		private function onBuddyState(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onBuddyUpdate(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onGettingDetail(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onGettingComplete(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onGroupUpdate(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onKilled(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onRedirection(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onSessionClose(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onSessionOpen(event:NateEvent):void
		{
			cloneEvent(event);
		}
		private function onSessionRequest(event:NateEvent):void
		{
			var v:Array = event.value;
			var s:Session = sm.addSession(v[1], v[2], v[3], v[0], null);
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_REQUEST);
			ne.value = [s];
			dispatchEvent(ne);
		}
		private function onSessionInvite(event:NateEvent):void
		{
			var v:Array = event.value;
			var s:Session = sm.addSession(v[1], v[2], v[3], null, v[0]);
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_INVITE);
			ne.value = [s];
			dispatchEvent(ne);
		}
		private function onShortMessage(event:NateEvent):void
		{
			var v:Array = event.value;
			var s:Session = sm.shortSession(v[2], v[3], v[4], v[0], v[1]);
			var ne:NateEvent = new NateEvent(NateEvent.SESSION_SHORT_MSG);
			ne.value = [s, v[0], v[1]];
			dispatchEvent(ne);
		}
	}
}