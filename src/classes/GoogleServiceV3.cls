public class GoogleServiceV3 {
	
	public static final String JWT_AUD = 'https://accounts.google.com/o/oauth2/token';
	public static final String JWT_GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
	public static final String JWT_ENDPOINT = 'https://accounts.google.com/o/oauth2/token';
	
	private SignServer signServer;
	private Blob privateKey;
	
	private AuthResponse auth = null;
	
	public GoogleServiceV3(SignServer signServer) {
		this.signServer = signServer;
	}
	
	public GoogleServiceV3(Blob privateKey) {
		this.privateKey = privateKey;
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
		} else if (this.privateKey != null) {
			str += '.' + jwt.sign(privateKey);
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
			this.auth = (AuthResponse)JSON.deserialize(res.getBody(), AuthResponse.class);
			return  true;
		}
		throw buildResponseException(res);
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
		if(this.auth != null) {
			String str = this.auth.token_type + ' ' + this.auth.access_token;
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
	
	private class AuthResponse {
		public String access_token;
		public String token_type;
		public Integer expire_in;
	}
	
}