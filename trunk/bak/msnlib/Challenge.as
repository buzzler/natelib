package msnlib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.HTML;
	
	public class Challenge extends EventDispatcher
	{
		public var xHTML:XML = 
		<html>
		<script>
		var strProdID	= 'PROD0090YUAUV#l_brace#2B',
			strProdKey	= 'YMM8C_H7KCQ2S_KL',
			arrMagic	= [10689, 7411, 0, 0, 0, 0];
		
		function CHL(strCHL) #l_brace#
			this.strCHL		= strCHL;
			this.strMD5		= md5_hex(strCHL + strProdKey);
			this.strConcat	= strCHL + strProdID;
			this.strConcat += bzRP('0', 8 - (this.strConcat.length % 8));
			this.fetchInts();
			this.fetchKey();
			this.strLo = bzHB(this.strMD5.slice( 0, 16));
			this.strHi = bzHB(this.strMD5.slice(16, 32));
			this.XOR();
		#r_brace#
		
		CHL.prototype.fetchInts = function() #l_brace#
			// Initialize arrays
			this.arrInts = [[], []];
			for(var i=0; i #l_shift# this.strMD5.length; i += 8)
				this.arrInts[0][i/8] = bigint(eval('0x'+bzSW(this.strMD5.slice(i, i+8),2)) #amp# 0x7FFFFFFF, 64);
			for(var j=0; j #l_shift# this.strConcat.length; j += 4)#l_brace#
				this.arrInts[1][j/4] = bigint(bzTI(this.strConcat.slice(j, j+4)), 64);
			#r_brace#
		#r_brace#
		
		CHL.prototype.fetchKey = function() #l_brace#
			var arrX7F = [32767, 32767, 1, 0, 0, 0],
				arrHi  = [0, 0, 0, 0, 0, 0],
				arrLo  = [0, 0, 0, 0, 0, 0];
		
			for(var i=0; i #l_shift# this.arrInts[1].length; i += 2) #l_brace#
				var objTemp = mod(mult(this.arrInts[1][i], arrMagic), arrX7F);
				    objTemp = mult(add(objTemp, arrHi), this.arrInts[0][0]);
				    objTemp = mod(add(objTemp, this.arrInts[0][1]), arrX7F);
		
				arrHi = mod(add(objTemp, this.arrInts[1][i+1]), arrX7F);
				arrHi = mod(add(mult(arrHi, this.arrInts[0][2]), this.arrInts[0][3]), arrX7F);
				
				arrLo = add(add(arrLo, objTemp), arrHi);
			#r_brace#
		
			arrLo = mod(add(arrLo, this.arrInts[0][3]), arrX7F);
			arrHi = mod(add(arrHi, this.arrInts[0][1]), arrX7F);
		
			arrLo  = bzHB(bzSW(bigint2str(arrLo, 16), 2));
			arrLo += bzRP('0', 32 - arrLo.length);
			arrHi  = bzHB(bzSW(bigint2str(arrHi, 16), 2));
			arrHi += bzRP('0', 32 - arrHi.length);
			
			this.strXORKey = arrHi + arrLo;
		#r_brace#
		
		CHL.prototype.XOR = function() #l_brace#
			var intPad = Math.max(this.strLo.length, this.strHi.length, this.strXORKey.length);
			this.strLo = bzRP('0', intPad - this.strLo.length) + this.strLo;
			this.strHi = bzRP('0', intPad - this.strHi.length) + this.strHi;
			this.strXORKey = (bzRP('0', intPad - this.strXORKey.length) + this.strXORKey).split('');
		
			var arrLoHi = [this.strLo.split(''), this.strHi.split('')];
		
			var arrOutput = ['', ''];
			for(var j=0; j #l_shift# intPad; j++) #l_brace#
				arrOutput[0] += arrLoHi[0][j] ^ this.strXORKey[j];
				arrOutput[1] += arrLoHi[1][j] ^ this.strXORKey[j];
			#r_brace#
		
			this.strLo = bzBH(arrOutput[0]);
			this.strHi = bzBH(arrOutput[1]);
			
			this.strHash = (bzRP('0', 16 - this.strLo.length) + this.strLo + 
						 	bzRP('0', 16 - this.strHi.length) + this.strHi).toLowerCase();
		#r_brace#
		
		
		
		
		
		
		function md5_hex(s)#l_brace# return binl2hex(core_md5(str2binl(s), s.length * 8));#r_brace#
		
		function core_md5(x, len) #l_brace#
			x[len #r_shift##r_shift# 5] |= 0x80 #l_shift##l_shift# ((len) % 32);
			x[(((len + 64) #r_shift##r_shift##r_shift# 9) #l_shift##l_shift# 4) + 14] = len;
		
			var a =  1732584193,
				b = -271733879,
				c = -1732584194,
				d =  271733878;
		
			for(var i = 0; i #l_shift# x.length; i += 16) #l_brace#
				var olda = a, oldb = b, oldc = c, oldd = d;
		
				a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
				d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
				c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
				b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
				a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
				d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
				c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
				b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
				a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
				d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
				c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
				b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
				a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
				d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
				c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
				b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);
		
				a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
				d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
				c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
				b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
				a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
				d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
				c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
				b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
				a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
				d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
				c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
				b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
				a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
				d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
				c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
				b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);
		
				a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
				d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
				c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
				b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
				a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
				d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
				c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
				b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
				a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
				d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
				c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
				b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
				a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
				d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
				c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
				b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);
		
				a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
				d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
				c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
				b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
				a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
				d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
				c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
				b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
				a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
				d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
				c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
				b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
				a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
				d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
				c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
				b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);
		
				a = safe_add(a, olda);
				b = safe_add(b, oldb);
				c = safe_add(c, oldc);
				d = safe_add(d, oldd);
			#r_brace#
		
			return Array(a, b, c, d);
		#r_brace#
		
		function md5_cmn(q, a, b, x, s, t	) #l_brace#	return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b); #r_brace#
		function md5_ff (a, b, c, d, x, s, t) #l_brace#	return md5_cmn((b #amp# c) | ((~b) #amp# d), a, b, x, s, t); #r_brace#
		function md5_gg (a, b, c, d, x, s, t) #l_brace#	return md5_cmn((b #amp# d) | (c #amp# (~d)), a, b, x, s, t); #r_brace#
		function md5_hh (a, b, c, d, x, s, t) #l_brace#	return md5_cmn(b ^ c ^ d, a, b, x, s, t); #r_brace#
		function md5_ii (a, b, c, d, x, s, t) #l_brace# return md5_cmn(c ^ (b | (~d)), a, b, x, s, t); #r_brace#
		
		function safe_add(x, y) #l_brace#
			var lsw = (x #amp# 0xFFFF) + (y #amp# 0xFFFF);
			var msw = (x #r_shift##r_shift# 16) + (y #r_shift##r_shift# 16) + (lsw #r_shift##r_shift# 16);
			return (msw #l_shift##l_shift# 16) | (lsw #amp# 0xFFFF);
		#r_brace#
		
		function bit_rol(num, cnt) #l_brace# return (num #l_shift##l_shift# cnt) | (num #r_shift##r_shift##r_shift# (32 - cnt)); #r_brace#
		
		function str2binl(str) #l_brace#
			var bin = Array(),
				mask = (1 #l_shift##l_shift# 8) - 1;
				
			for(var i=0; i #l_shift# str.length * 8; i += 8)
				bin[i#r_shift##r_shift#5] |= (str.charCodeAt(i/8) #amp# mask) #l_shift##l_shift# (i%32);
		
			return bin;
		#r_brace#
		
		function binl2hex(binarray) #l_brace#
			var str = '';
			
			for(var i=0; i #l_shift# binarray.length * 4; i++)
				str += '0123456789abcdef'.charAt((binarray[i#r_shift##r_shift#2] #r_shift##r_shift# ((i%4)*8+4)) #amp# 0xF) +
		        	   '0123456789abcdef'.charAt((binarray[i#r_shift##r_shift#2] #r_shift##r_shift# ((i%4)*8  )) #amp# 0xF);
		
			return str;
		#r_brace#
		
		
		
		
		
		var bpe   = 0,
			mask  = 0,
			radix = 1;
		
		var digitsStr = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef';
		
		for(bpe=0; (1#l_shift##l_shift#(bpe+1)) #r_shift# (1#l_shift##l_shift#bpe); bpe++);
		bpe #r_shift##r_shift#= 1;
		mask  = (1 #l_shift##l_shift# bpe) - 1;
		radix = mask + 1;
		
		var t = new Array(0);
		var ss = t,
			s4 = t,
			s5 = t,
			s6 = t;
		
		var md_q1 = t,
			md_q2 = t,
			md_q3 = t,
			md_r  = t,
			md_r1 = t,
			md_r2 = t,
			md_tt = t; 
		
		
		function bigint(t, bits) #l_brace#
			var buff = new Array(Math.ceil(bits / bpe) + 1);
		 	copyInt(buff, t);
			return buff;
		#r_brace#
		
		function str2bigint(s, base) #l_brace#
			var k = s.length;
			var x = bigint(0, base * k), i, y;
			for(i=0; i #l_shift# k; i++) #l_brace#
				var d = digitsStr.indexOf(s.substring(i, i + 1), 0);
				if(base #l_shift#= 36 #amp##amp# d #r_shift#= 36) d -= 26;
		
		  		multInt(x, base);
				addInt(x, d);
		  	#r_brace#
		
			for(k=x.length; k #r_shift# 0 #amp##amp# !x[k-1]; k--);
		  	y = new Array(++k);
		
		 	for(i=0; i #l_shift# k; i++) y[i] = (x[i] || 0);
		 	return y;
		#r_brace#
		
		function bigint2str(x, base) #l_brace#
			if(s6.length != x.length) s6 = dup(x);
		  	else copy(s6, x);
		
			var s = '';
			while(!(s6.join('') == 0)) #l_brace#
		  		var t = divInt(s6, base);
		  		s = digitsStr.substring(t, ++t) + s;
			#r_brace#
			
		  	if(s.length == 0) s = '0';
			return s;
		#r_brace#
		
		
		function mod(x, n) #l_brace#
			var ans = dup(x);
			__mod(ans, n);
			return trim(ans, 1);
		#r_brace#
		
		function mult(x, y) #l_brace#
			var ans = dup(x, x.length + y.length);
			__mult(ans, y);
			return trim(ans, 1);
		#r_brace#
		
		function add(x,y) #l_brace#
			var ans = dup(x, (x.length #r_shift# y.length ? x.length + 1 : y.length + 1)); 
			__add(ans, y);
			return trim(ans, 1);
		#r_brace#
		
		
		function copyInt(x, n) #l_brace#
			for(var c=n, i=0; i #l_shift# x.length; i++) #l_brace#
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
		#r_brace#
		
		function addInt(x, n) #l_brace#
			var k = x.length,
				c = 0, b;
				
			x[0] += n;
		 	for(var i=0; i #l_shift# k; i++) #l_brace#
				c += x[i];
				b  = 0;
				
				if(c #l_shift# 0) #l_brace#
					b  = -(c #r_shift##r_shift# bpe);
			  		c += b * radix;
				#r_brace#
			
				x[i] = c #amp# mask;
				c = (c#r_shift##r_shift#bpe) - b;
				if(!c) return;
			#r_brace#
		#r_brace#
		
		function multInt(x, n) #l_brace#
			if(!n) return;
			
			var k = x.length, c = 0, b;
			for(var i=0; i #l_shift# k; i++) #l_brace#
				c += x[i] * n;
				b  = 0;
				
				if(c #l_shift# 0) #l_brace#
			  		b  = -(c #r_shift##r_shift# bpe);
			  		c += b * radix;
				#r_brace#
			
				x[i] = c #amp# mask;
				c = (c #r_shift##r_shift# bpe) - b;
		 	#r_brace#
		#r_brace#
		
		function divInt(x, n) #l_brace#
			var r = 0, s;
		 	for(var i=x.length-1; i #r_shift#= 0; i--) #l_brace#
				s = r * radix + x[i];
				x[i] = Math.floor(s / n);
				r = s % n;
			#r_brace#
			return r;
		#r_brace#
		
		
		function greaterShift(x,y,shift) #l_brace#
			var kx = x.length, ky = y.length;
			var k  = (((kx + shift) #l_shift# ky) ? (kx + shift) : ky);
			var i  = 0;
			
		  	for(i=ky-1-shift; i#l_shift#kx #amp##amp# i#r_shift#=0; i++) 
				if(x[i]) return 1;
				
			for(i=kx-1+shift; i#l_shift#ky; i++)
				if(y[i]) return 0;
				
			for(i=k-1; i#r_shift#=shift; i--)
				if(x[i-shift] #r_shift# y[i]) return 1;
				else if(x[i-shift] #l_shift# y[i]) return 0;
		
			return 0;
		#r_brace#
		
		function rightShift(x, n) #l_brace#
			var i, k = Math.floor(n / bpe);
		  	if(k) #l_brace#
				for(i=0; i #l_shift# x.length - k; i++) x[i] = x[i+k];
				for(; i #l_shift# x.length; i++) x[i] = 0;
				n %= bpe;
		  	#r_brace#
		
			for(i = 0; i #l_shift# x.length - 1; i++) x[i] = mask #amp# ((x[i+1] #l_shift##l_shift# (bpe-n)) | (x[i] #r_shift##r_shift# n));
		  	x[i] #r_shift##r_shift#= n;
		#r_brace#
		
		function leftShift(x,n) #l_brace#
			var i, k = Math.floor(n / bpe);
			if(k) #l_brace#
				for(i=x.length; i #r_shift#= k; i--) x[i] = x[i-k];
				for(; i #r_shift#= 0; i--) x[i] = 0;  
				n %= bpe;
		  	#r_brace#
		  
		  	if(!n) return;
		  	for(i=x.length-1; i #r_shift# 0; i--) x[i] = mask #amp# ((x[i] #l_shift##l_shift# n) | (x[i-1] #r_shift##r_shift# (bpe-n)));
			x[i] = mask #amp# (x[i] #l_shift##l_shift# n);
		#r_brace#
		
		function linCombShift(x,y,b,ys) #l_brace#
			var k  = x.length #l_shift# ys+y.length ? x.length : ys+y.length,
				kk = x.length, c = 0, i;
		
			for(i=ys; i #l_shift# k; i++) #l_brace#
				c += x[i] + b * y[i-ys];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
			for(i=k; c #amp##amp# i #l_shift# kk; i++) #l_brace#
				c += x[i];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
		#r_brace#
		
		function subShift(x, y, ys) #l_brace#
			var k  = x.length#l_shift#ys+y.length ? x.length : ys+y.length,
				kk = x.length, c = 0, i;
				
			for(i=ys; i #l_shift# k; i++) #l_brace#
				c += x[i] - y[i-ys];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
			for(i=k; c #amp##amp# i #l_shift# kk; i++) #l_brace#
				c += x[i];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
		#r_brace#
		
		function addShift(x,y,ys) #l_brace#
			var kk = x.length;
			var k  = kk #l_shift# ys + y.length ? kk : ys + y.length,
				c  = 0, i = ys;
		
			for(; i #l_shift# k; i++) #l_brace#
				c += x[i] + y[i-ys];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
			for(i = k; c #amp##amp# i #l_shift# kk; i++) #l_brace#
				c += x[i];
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
		#r_brace#
		
		
		function __add(x,y) #l_brace#
		  	var k = Math.max(x.length, y.length);
			for(var c=0,i=0; i #l_shift# k; i++) #l_brace#
				c += (x[i] || 0) + (y[i] || 0);
				x[i] = c #amp# mask;
				c #r_shift##r_shift#= bpe;
			#r_brace#
		#r_brace#
		
		function __mult(x,y) #l_brace#
			if(ss.length != x.length * 2) ss = new Array(2 * x.length);
			copyInt(ss, 0);
		  
			for(var i=0; i #l_shift# y.length; i++)
				if(y[i]) linCombShift(ss,x,y[i],i);
		
			copy(x, ss);
		#r_brace#
		
		function __mod(x,n) #l_brace#
		 	if(s4.length != x.length) s4 = dup(x);
			else copy(s4, x);
				
			if(s5.length != x.length) s5 = dup(x);  
			__divide(s4, n, s5, x);
		#r_brace#
		
		function __divide(x,y,q,r) #l_brace#
			var kx, ky;
		  	copy(r, x);
		  	
		  	for(ky = y.length; y[ky-1] == 0; ky--);
		  	for(kx = r.length; r[kx-1] == 0 #amp##amp# kx #r_shift# ky; kx--);
		
			var b = y[ky - 1], a = 0;
		  	for(; b; a++) b#r_shift##r_shift#=1;
		  	a = bpe - a;
			leftShift(y, a);
			leftShift(r, a);
		
			copyInt(q, 0);
			while(!greaterShift(y, r, kx - ky)) #l_brace#
				subShift(r, y, kx - ky);
				q[kx - ky]++;
			#r_brace#
		
			var y1, y2, c;
			for(var i=kx-1; i #r_shift#= ky; i--) #l_brace#
				if(r[i] == y[ky-1]) q[i - ky]=mask;
				else q[i-ky] = Math.floor((r[i] * radix + r[i-1]) / y[ky-1]);	
		
				for(;;) #l_brace#
			  		y2  = (ky #r_shift# 1 ? y[ky-2] : 0) * q[i-ky];
					c   = y2 #r_shift##r_shift# bpe;
			  		y2 #amp#= mask;
			  		y1  = c + q[i-ky] * y[ky-1];
			  		c   = y1 #r_shift##r_shift# bpe;
			  		y1 #amp#= mask;
		
					if(!(c == r[i] ? y1 == r[i-1] ? y2 #r_shift# (i #r_shift# 1 ? r[i-2] : 0) : y1 #r_shift# r[i-1] : c #r_shift# r[i])) break; 
					q[i-ky]--;
				#r_brace#
		
				linCombShift(r, y, -q[i-ky], i-ky);
				if(negative(r)) #l_brace#
			  		addShift(r, y, i-ky);
			  		q[i-ky]--;
				#r_brace#
		  	#r_brace#
		
		  	rightShift(y, a);
		  	rightShift(r, a);
		#r_brace#
		
		
		function trim(x, k) #l_brace#
			var y = [];
			for(var i=0; i #l_shift# x.length + k; i++)
				if(x[i] || k--) y[i] = x[i] || 0;
				else break;
		
			return y;
		#r_brace#
		
		function negative(x) #l_brace#
			return ((x[x.length-1] #r_shift##r_shift# (bpe - 1)) #amp# 1);
		#r_brace#
		
		function dup(x) #l_brace#
			var buff = [];
			for(var i=0; i #l_shift# x.length; i++) buff[i] = x[i];
			return buff;
		#r_brace#
		
		function copy(x, y) #l_brace#
		 	var k = Math.max(x.length, y.length);
			for(var i=0; i #l_shift# k; i++) x[i] = y[i] || 0;
		#r_brace#
		
		
		
		
		
		String.prototype.swap = function(intChars) #l_brace#
			var strPadded = '0'.repeat(this.length % intChars) + this;
			var strOutput = '';
			for(var i=0; i #l_shift# strPadded.length; i+=intChars)
				strOutput = strPadded.slice(i, i+intChars) + strOutput;
			return strOutput;
		#r_brace#
		
		function bzSW(this_obj, intChars)#l_brace#
			var strPadded = bzRP('0', this_obj.length % intChars) + this_obj;
			var strOutput = '';
			for(var i=0; i #l_shift# strPadded.length; i+=intChars)
				strOutput = strPadded.slice(i, i+intChars) + strOutput;
			return strOutput;	
		#r_brace#
		
		String.prototype.repeat = function(ix) #l_brace#
			if(ix #l_shift#= 0) return '';
			return new Array(++ix).join(this);
		#r_brace#
		
		function bzRP(this_obj, ix)#l_brace#
			if(ix #l_shift#= 0) return '';
			return new Array(++ix).join(this_obj);	
		#r_brace#
		
		String.prototype.toint = function(blnBE) #l_brace#
			if(typeof blnBE == 'undefined') blnBE = true;
		
			var strChars = this.split('');
			if(blnBE) strChars = strChars.reverse();
		
			var strHex = bzTH(strChars.join(''));
			return eval('0x' + strHex);
		#r_brace#
		
		function bzTI(this_obj, blnBE)#l_brace#
			if(typeof blnBE == 'undefined') blnBE = true;
		
			var strChars = this_obj.split('');
			if(blnBE) strChars = strChars.reverse();
		
		//	var strHex = strChars.join('').tohex();
			var strHex = bzTH(strChars.join(''));
		
			return eval('0x' + strHex);
		#r_brace#
		
		function bzTH(this_obj)#l_brace#
			var result = '';
			for (var i = 0 ; i #l_shift# this_obj.length ; i++)
				result += this_obj.charCodeAt(i).toString(16);
			return result;
		#r_brace#
		
		var arrHexDigits = [0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f'],
			arrBinDigits = ['0000','0001','0010','0011','0100','0101','0110','0111','1000','1001','1010','1011','1100','1101','1110','1111'],
			objHexBinMap = #l_brace##r_brace#,
			objBinHexMap = #l_brace##r_brace#;
		
		for(var i in arrHexDigits) objHexBinMap[arrHexDigits[i]] = arrBinDigits[i];
		for(var i in arrBinDigits) objBinHexMap[arrBinDigits[i]] = arrHexDigits[i];
		
		arrHexDigits = arrBinDigits = null;
		
		String.prototype.hex2bin = function() #l_brace#
			var strChars = this.toLowerCase().split('');
			for(var i in strChars)
				strChars[i] = objHexBinMap[strChars[i]];
		
			return strChars.join('');
		#r_brace#
		
		function bzHB(this_obj)#l_brace#
			var strChars = this_obj.toLowerCase().split('');
			for(var i in strChars)
				strChars[i] = objHexBinMap[strChars[i]];
		
			return strChars.join('');
		#r_brace#
		
		String.prototype.bin2hex = function() #l_brace#
			var strInput = new String('0').repeat(this.length%4) + this,
				strOutput = '';
		
			for(var i=0; i #l_shift# strInput.length; i+=4)
				strOutput += objBinHexMap[strInput.slice(i, i+4)];
		
			return strOutput;
		#r_brace#
		
		function bzBH(this_obj)#l_brace#
			var strInput = bzRP(new String('0'), this_obj.length%4) + this_obj,
				strOutput = '';
		
			for(var i=0; i #l_shift# strInput.length; i+=4)
				strOutput += objBinHexMap[strInput.slice(i, i+4)];
		
			return strOutput;
		#r_brace#
		
		function bzTest()#l_brace#
			var objCHL = new CHL('22210219642164014968');
			alert(objCHL.strHash);
			document.getElementById('replace').innerHTML = objCHL.strHash;
		#r_brace#
		
		function ping(chl)#l_brace#
			var objCHL = new CHL(chl);
			return objCHL.strHash;
		#r_brace#
		</script>
		<body>
		</body>
		</html>;
		
		
		private	var html:HTML;
		private	var ping:String;
		private	var pong:String;
		private var productId:String;

		public function Challenge():void
		{
			this.html = new HTML();
			html.addEventListener(Event.COMPLETE, onLoad);
		}
		public function calcPing(ping:String):void
		{
			this.ping = ping;
			if (this.ping == null)
				return;

			var temp:String = xHTML.toString();
			var exp1:RegExp = /#r_brace#/g;
			var exp2:RegExp = /#l_brace#/g;
			var exp3:RegExp = /#r_shift#/g;
			var exp4:RegExp = /#l_shift#/g;
			var exp5:RegExp = /#amp#/g;
			temp = temp.replace(exp1, "}");
			temp = temp.replace(exp2, "{");
			temp = temp.replace(exp3, ">");
			temp = temp.replace(exp4, "<");
			temp = temp.replace(exp5, "&");
			html.htmlLoader.loadString(temp);
		}
		public function getPong():String
		{
			return this.pong;
		}
		public function getProductId():String
		{
			return this.productId;
		}
		private function onLoad(event:Event):void
		{
			this.productId = html.htmlLoader.window.strProdID;
 			this.pong = html.htmlLoader.window.ping(this.ping);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}