package com.mobsword.natelib.managers
{
	import com.mobsword.natelib.constants.Command;
	import com.mobsword.natelib.data.Message;
	import com.mobsword.natelib.objects.Account;
	import com.adobe.crypto.MD5;
	import com.mobsword.natelib.utils.Codec;
	/**
	* ...
	* @author Default
	*/
	public class MessageManager extends Manager
	{
		public	function MessageManager(a:Account)
		{
			super(a);
		}

		public	function genPVER():Message
		{
			var m:Message = new Message();
			m.command	= Command.PVER;
			m.isText	= true;
			m.param		= ['3.615', '3.0'];
			return m;
		}

		public	function genAUTH():Message
		{
			var m:Message = new Message();
			m.command	= Command.AUTH;
			m.isText	= true;
			m.param		= ['DES'];
			return m;
		}

		public	function genREQS():Message
		{
			var m:Message = new Message();
			m.command	= Command.REQS;
			m.isText	= true;
			m.param		= ['DES', account.data.email];
			return m;
		}

		public	function genLSIN():Message
		{
			var id:String	= account.data.email.substr(0, account.data.email.indexOf('@'));
			var md5:String	= MD5.hash(account.data.password + id);
			var m:Message	= new Message();
			m.command	= Command.LSIN;
			m.isText	= true;
			m.param		= [account.data.email, md5, 'MD5', '3.615', 'UTF8'];
			return m;
		}

		public	function genLIST():Message
		{
			var m:Message = new Message();
			m.command	= Command.LIST;
			m.isText	= true;
			return m;
		}

		public	function genGLST():Message
		{
			var m:Message = new Message();
			m.command	= Command.GLST;
			m.isText	= true;
			m.param		= ['0'];
			return m;
		}

		public	function genONST(state:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ONST;
			m.isText	= true;
			m.param		= [state, '0'];
			return m;
		}

		public	function genCONF():Message
		{
			var m:Message = new Message();
			m.command	= Command.CONF;
			m.isText	= true;
			m.param		= ['3821', '0'];
			return m;
		}

		public	function genCNIK(nick:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.CNIK;
			m.isText	= true;
			m.param		= [Codec.encode(nick)];
			return m;
		}

		public	function genADSB(email:String, g:String, msg:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADSB;
			m.isText	= true;
			m.param		= ['REQST', '%00', Codec.encode(email), g, Codec.encode(msg)];
			return m;
		}

		public	function genADDB(email:String, g:String, list:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADDB;
			m.isText	= true;
			m.param		= [list, g, email];
			return m;
		}

		public	function genRMVB(email:String, g:String, list:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.RMVB;
			m.isText	= true;
			m.param		= [list, g, email, '0'];
			return m;
		}

		public	function genADDG(n:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADDG;
			m.isText	= true;
			m.param		= [account.gm.data.version, Codec.encode(n)];
			return m;
		}

		public	function genRENG(g:String, n:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.RENG;
			m.isText	= true;
			m.param		= [account.gm.data.version, g, Codec.encode(n)];
			return m;
		}

		public	function genRMVG(g:String):void
		{
			var m:Message = new Message();
			m.command	= Command.RMVG;
			m.isText	= true;
			m.param		= [account.gm.data.version, g];
			return m;
		}

		public	function genPING():Message
		{
			var m:Message = new Message();
			m.command	= Command.PING;
			m.isText	= true;
			return m;
		}

		public	function genRESS():Message
		{
			var m:Message = new Message();
			m.command	= Command.RESS;
			m.isText	= true;
			return m;
		}

		public	function genCTOC(email:String, msg:Message):Message
		{
			var m:Message = new Message();
			m.command	= Command.CTOC;
			m.isBinary	= true;
			m.param		= [email, 'N'];
			m.data		= msg.toString();
			return m;
		}

		public	function genINVT(host:String, port:int, s:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.INVT;
			m.isEmbed	= true;
			m.param		= [account.data.email, host, port.toString, s];
			return m;
		}

		public	function genENTR(s:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ENTR;
			m.isText	= true;
			m.param		= [account.data.email, Codec.encode(account.data.nick), Codec.encode(account.data.name), s, 'UTF8', 'P'];
			return m;
		}

		public	function genMESG(msg:Message):Message
		{
			var m:Message = new Message();
			m.command	= Command.MESG;
			m.isText	= true;
			m.param		= msg.toString();
			return m;
		}

		public	function genMSG(msg:String, font:String, color:String, type:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.MSG;
			m.isEmbed	= true;
			m.param		= [font+'%09'+color+'%09'+type+'%09'+Codec.encode(msg)];
			return m;
		}

		public	function genTYPING(type:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.TYPING;
			m.isEmbed	= true;
			m.param		= [type];
			return m;
		}

		public	function genEMOTICON(custom:Boolean):Message
		{
			var m:Message = new Message();
			m.command	= Command.EMOTICON;
			m.isEmbed	= true;
			if (custom)
				m.param	= ['USECUST%091'];
			else
				m.param	= ['USECUST%090'];
			return m;
		}
	}
}



