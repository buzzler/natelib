package msnlib
{
	import flash.xml.XMLDocument;
	import mx.utils.XMLUtil;
	import mx.collections.ArrayCollection;
	import mx.containers.Accordion;
	import flash.xml.XMLNode;
	
	public class BuddyManager
	{
		public static function getOnlineByGroup(a:Account):XML
		{
			var xml_full:String = "";
			var xml_pre	:String;
			for each(var g:Group in a.groups)
			{
				xml_pre = "<group name='"+escape(g.name)+"' value='"+g.id+"' type='group' icon='ico_group' blocked='false'>"
				for each(var b:Buddy in g.buddies)
				{
					if (b.status == Account.STATUS_DISAVAILABLE)
						continue;
	  				xml_pre += "<user name='"+escape(b.nick)+"' value='"+b.user+"' type='user' icon='"+b.status;
					xml_pre += "' blocked='"+b.isBlock.toString()+"'/>";
				}
				xml_full += xml_pre+"</group>";
			}
			xml_full = "<root name='MSN Root'>" + xml_full + "</root>";
			return XML(xml_full);
		}

		public static function getAllByGroup(a:Account):XML
		{
			var xml_full:String = "";
			var xml_pre	:String;
			for each(var g:Group in a.groups)
			{
				xml_pre = "<group name='"+escape(g.name)+"' value='"+g.id+"' type='group' icon='ico_group' blocked='false'>"
				for each(var b:Buddy in g.buddies)
				{
					xml_pre += "<user name='"+escape(b.nick)+"' value='"+b.user+"' type='user' icon='"+b.status;
					xml_pre += "' blocked='"+b.isBlock.toString()+"'/>";
				}
				xml_full += xml_pre+"</group>";
			}
			xml_full = "<root name='MSN Root'>" + xml_full + "</root>";
			return XML(xml_full);
		}

		public static function toXML(b:Buddy):XML
		{
			return XML("<user name='"+escape(b.nick)+"' value='"+b.user+"' type='user' icon='"+b.status+"' blocked='"+b.isBlock.toString()+"'/>");
		}
		
		public static function getAllByOnline(a:Account):XMLDocument
		{
			var buddies:Array = a.buddies;
			var i:int;
			var j:int;
			var temp		:String;
			var xml_online	:String = "";
			var xml_offline	:String = "";
			var xml_full	:String;
			for (i = 0 ; i < buddies.length ; i++)
			{
				temp = "<node label='"+buddies[i].user+"' data='"+buddies[i].user+"' ico='ico_user'/>";
				if (buddies[i].status == Account.STATUS_DISAVAILABLE)
					xml_offline	+= temp;
				else
					xml_online += temp;
			}
			xml_full =	"<?xml version='1.0' encoding='utf-8'?><node label='MSN Root'>";
			xml_full +=	"<node label='Online' data='NLN' ico='ico_group'>";
			xml_full +=	xml_online;
			xml_full +=	"</node>";
			xml_full +=	"<node label='Offline' data='FLN' ico='ico_group'>";
			xml_full +=	xml_offline;
			xml_full +=	"</node>";
			xml_full +=	"</node>";
			return XMLUtil.createXMLDocument(xml_full);
		}
		
		public static function getOnline(a:Account):Array
		{
			var buddies:Array = a.buddies;
			var i:int;
			var j:int;
			var xml_online	:Object;
			var xml_full	:Array = new Array();
			for (i = 0 ; i < buddies.length ; i++)
			{
				if (buddies[i].status != Account.STATUS_DISAVAILABLE)
				{
					xml_online = new Object();
					xml_online["label"] = buddies[i].nick;
					xml_online["data"] = buddies[i].user;
					xml_full.push(xml_online);
				}
			}
			return xml_full;
		}

		public static function getOnlineToAC(a:Account):ArrayCollection
		{
			var buddies:Array = a.buddies;
			var i:int;
			var j:int;
			var xml_online	:ArrayCollection;
			var xml_full	:ArrayCollection = new ArrayCollection();
			for (i = 0 ; i < buddies.length ; i++)
			{
				if (buddies[i].status != Account.STATUS_DISAVAILABLE)
				{
					xml_online = new ArrayCollection();
					xml_online.addItem(buddies[i].nick);
					xml_online.addItem(buddies[i].user);
					xml_full.addItem(xml_online);
				}
			}
			return xml_full;
		}
	}
}