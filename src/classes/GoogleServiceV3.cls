public class GoogleServiceV3 {
	
	public static final String JWT_AUD = 'https://accounts.google.com/o/oauth2/token';
	public static final String JWT_GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
	public static final String JWT_ENDPOINT = 'https://accounts.google.com/o/oauth2/token';
	
	private SignServer signServer;
	
	private String token_type;
	private String access_token;
	
	public GoogleServiceV3() {
	}
	
	public GoogleServiceV3(SignServer signServer) {
		this.signServer = signServer;
	}
	
	public Boolean authenticate(JWT jwt) {
		if (jwt.aud == null) {
			jwt.aud = JWT_AUD;
		}
		if (jwt.iat == null) {
			jwt.iat = Datetime.now();
		}
		if (jwt.exp == null) {
			jwt.exp = jwt.iat.addHours(1);
		}
		String str = jwt.getEncodedString();
		if (this.signServer != null) {
			str += '.' + signServer.sign(str);
		} else {
			throw new GoogleServiceException('Can not sign to jwt');
		}
		System.debug('JWT:' + jwt);
		HttpRequest req = createRequest();
		String content = 'grant_type=' + EncodingUtil.urlEncode(JWT_GRANT_TYPE, 'utf-8') +
			'&assertion=' + EncodingUtil.urlEncode(str, 'utf-8');
		req.setEndpoint(JWT_ENDPOINT);
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setMethod('POST');
		req.setBody(content);
		
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			GoogleOAuth.AuthResponse auth = (GoogleOAuth.AuthResponse)JSON.deserialize(res.getBody(), GoogleOAuth.AuthResponse.class);
			this.token_type = auth.token_type;
			this.access_token = auth.access_token;
			return  true;
		}
		throw buildResponseException(res);
	}
	
	public void setAccessToken(String tokenType, String token) {
		this.token_type = tokenType;
		this.access_token = token;
	}
	
	public String get(String url) {
		return get(url, null);
	}
	
	public String get(String url, Map<String, String> params) {
		Boolean first = true;
		if (params != null && params.size() > 0) {
			for (String key : params.keySet()) {
				url += (first ? '?' : '&');
				url += EncodingUtil.urlEncode(key, 'utf-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'utf-8');
				first = false;
			}
		}
		HttpRequest req = createRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	public String post(String url, String jsonStr) {
		HttpRequest req = createRequest();
		req.setEndpoint(url);
		req.setMethod('POST');
		req.setHeader('Content-Type','application/json');
		req.setBody(jsonStr);
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	public String patch(String url, String jsonStr) {
		HttpRequest req = createRequest();
		req.setEndpoint(url);
		req.setMethod('POST');
		req.setHeader('X-HTTP-Method-Override', 'PATCH');
		req.setHeader('Content-Type','application/json');
		req.setBody(jsonStr);
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	public String put(String url, String jsonStr) {
		HttpRequest req = createRequest();
		req.setEndpoint(url);
		req.setMethod('PUT');
		req.setHeader('Content-Type','application/json');
		req.setBody(jsonStr);
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	public String doDelete(String url) {
		HttpRequest req = createRequest();
		req.setEndpoint(url);
		req.setMethod('DELETE');
		HttpResponse res = sendRequest(req);
		if (isOK(res)) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	private boolean isOK(HttpResponse res) {
		return res.getStatusCode() >= 200 && res.getStatusCode() < 300;
	}
	
	private HttpRequest createRequest() {
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		if(this.access_token != null && this.token_type != null) {
			String str = this.token_type + ' ' + this.access_token;
			req.setHeader('Authorization', str);
		}
		return req;
	}
	
	private HttpResponse sendRequest(HttpRequest req) {
		Http http = new Http();
		try {
			System.debug('HttpRequest :' +req);
			HttpResponse res = http.send(req);
			System.debug('STATUS:' + res.getStatusCode());
			return res;
		} catch( System.Exception e) {
			throw new GoogleServiceException(e);
		}
	}
	
	private GoogleServiceException buildResponseException(HttpResponse res) {
		String msg = 'STATUS: ' + res.getStatus() + 
			'\nSTATUS_CODE: ' + res.getStatusCode() +
			'\nBODY: ' + res.getBody();
		System.debug(msg);
		return new GoogleServiceException(msg);
	}
	
}