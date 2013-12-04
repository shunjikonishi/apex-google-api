public class GoogleOAuth {

	public static final String AUTH_URL = 'https://accounts.google.com/o/oauth2/auth';
	public static final String TOKEN_URL = 'https://accounts.google.com//o/oauth2/token';
	
	public GoogleOAuth(String client_id, String secret, String scope, String redirect_uri) {
		this.client_id = client_id;
		this.secret = secret;
		this.scope = scope;
		this.redirect_uri = redirect_uri;
		
		this.offline_access = false;
		this.force_approval_prompt = false;
	}
	
	public String client_id { get; private set;}
	public String secret { get; private set;}
	public String scope { get; set;}
	public String redirect_uri { get; set;}
	
	public String state { get; set;}
	public Boolean offline_access { get; set;}
	public Boolean force_approval_prompt { get; set;}
	public String login_hint { get; set;}
	
	public String getLoginUrl() {
		String ret = AUTH_URL + 
			'?client_id=' + EncodingUtil.urlEncode(this.client_id, 'utf-8') +
			'&response_type=code' +
			'&redirect_uri=' + EncodingUtil.urlEncode(this.redirect_uri, 'utf-8') +
			'&scope=' + EncodingUtil.urlEncode(this.scope, 'utf-8');
		if (this.state != null) {
			ret += '&state=' + EncodingUtil.urlEncode(this.state, 'utf-8');
		}
		if (this.offline_access) {
			ret += '&access_type=offline';
		}
		if (this.force_approval_prompt) {
			ret += '&approval_prompt=force';
		}
		if (this.login_hint != null) {
			ret += '&login_hint=' + EncodingUtil.urlEncode(this.login_hint, 'utf-8');
		}
		return ret;
	}

	public AuthResponse authenticate(String code) {
		return doAuthenticate(code, false);
	}
	
	public AuthResponse refreshToken(String token) {
		return doAuthenticate(token, true);
	}
	
	private AuthResponse doAuthenticate(String code, Boolean refresh) {
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setMethod('POST');
		req.setEndpoint(TOKEN_URL);
		String content = 'grant_type=' + (refresh ? 'refresh_token' : 'authorization_code') + 
			'&client_id=' + EncodingUtil.urlEncode(this.client_id, 'utf-8') +
			'&client_secret=' + EncodingUtil.urlEncode(this.secret, 'utf-8');
		if (refresh) {
			content += '&refresh_token=' + EncodingUtil.urlEncode(code, 'utf-8');
		} else { 
			content += '&redirect_uri=' + EncodingUtil.urlEncode(this.redirect_uri, 'utf-8') +
			'&code=' + EncodingUtil.urlEncode(code, 'utf-8');
		} 
		req.setBody(content);
		
		Http http = new Http();
		try {
			System.debug('HttpRequest :' + req);
			HttpResponse res = http.send(req);
			System.debug('STATUS:' + res.getStatusCode());
			
			return  (AuthResponse)JSON.deserialize(res.getBody(), AuthResponse.class);
		} catch( System.Exception e) {
			throw new GoogleServiceException(e);
		}
	}
	
	public void revokeToken(String token) {
		String url = 'https://accounts.google.com/o/oauth2/revoke?token=' + EncodingUtil.urlEncode(token, 'utf-8');
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		req.setMethod('GET');
		req.setEndpoint(url);
		
		Http http = new Http();
		try {
			System.debug('HttpRequest :' + req);
			HttpResponse res = http.send(req);
			System.debug('STATUS:' + res.getStatusCode());
		} catch( System.Exception e) {
			throw new GoogleServiceException(e);
		}
	}
	
	
	public class AuthResponse {
		public String access_token { get;}
		public String refresh_token { get;}
		public Long expires_in { get;}
		public String token_type { get;} 
	}
}