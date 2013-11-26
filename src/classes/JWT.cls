public class JWT {
	
	private Header header = new Header();
	private ClaimSet claimSet = new ClaimSet();
	
	public String iss {
		get { return this.claimSet.iss;}
		set { this.claimSet.iss = value;}
	}
	
	public void addScope(String v) {
		String oldValue = this.claimSet.scope;
		if (oldValue != null) {
			v = oldValue + ' ' + v;
		}
		this.claimSet.scope = v;
	}
	
	public String aud {
		get { return this.claimSet.aud;}
		set { this.claimSet.aud = value;}
	}
	
	public Datetime iat {
		get { return this.claimSet.iat == 0 ? null : Datetime.newInstance(this.claimSet.iat * 1000);}
		set { this.claimSet.iat = value.getTime() / 1000;}
	}
	
	public Datetime exp {
		get { return this.claimSet.exp == 0 ? null : Datetime.newInstance(this.claimSet.exp * 1000);}
		set { this.claimSet.exp = value.getTime() / 1000;}
	}
	
	public override String toString() {
		return this.header.toString() + '.' + this.claimSet.toString();
	}
	
	public String getEncodedString() {
		return base64(this.header.toString()) + '.' + base64(this.claimSet.toString());
	}
	
	public String sign(Blob privateKey) {
		String input = getEncodedString();
		Blob ret = Crypto.sign('RSA', Blob.valueOf(input), privateKey);
		return input + '.' + base64(ret);
	}
	
	private static String base64(String str) {
		return base64(Blob.valueOf(str));
	}

	private static String base64(Blob b) {
		String ret = EncodingUtil.base64Encode(b);
		ret = ret.replaceAll('\\+', '-');
		ret = ret.replaceAll('/', '_');
		ret = ret.replaceAll('=', '');
		return ret;
	}
	
	private class ClaimSet {
		
		public String iss;
		public String scope;
		public String aud;
		public Long exp;
		public Long iat;
		
		public override String toString() {
		    String format = '"iss": "{0}", "scope": "{1}", "aud": "{2}", "exp": {3}, "iat": {4}';
			List<String> input = new List<String>();
			input.add(iss);
			input.add(scope);
			input.add(aud);
			input.add(String.valueOf(exp));
			input.add(String.valueOf(iat));
			return '{' + String.format(format, input) + '}';
		}
	}
	
	private class Header {
		
		public String alg = 'RS256';
		public String typ = 'JWT';
		
		public override String toString() {
			String format = '"alg":"{0}","typ":"{1}"';
			List<String> input = new List<String>();
			input.add(alg);
			input.add(typ);
			return '{' + String.format(format, input) + '}';
		}
	}
		
}