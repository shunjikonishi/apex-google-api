public class GoogleServiceV3 {
	
	public static final String JWT_AUD = 'https://accounts.google.com/o/oauth2/token';
	public static final String JWT_GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:jwt-bearer';
	public static final String JWT_ENDPOINT = 'https://accounts.google.com/o/oauth2/token';
	
	public static final Integer AUTH = 1;
	public static final Integer BAD_AUTH = 2;
	public static final Integer NOT_VERIFIED = 3;
	public static final Integer TERMS_NOT_AGREED = 4;
	public static final Integer CAPTCHA_REQUIRED = 5;
	public static final Integer UNKNOWN = 6;
	public static final Integer ACCOUNT_DELETED = 7;
	public static final Integer ACCOUNT_EXPIRED = 8;
	public static final Integer SERVICE_DISABLED = 9;
	public static final Integer SERVICE_UNAVAILABLE = 10;
	public static final Integer NO_MATCH = 99;
	
	private String serviceName;
	
	private Boolean useClientLoginAuthentication = false;
	private String clientLoginToken = null;
	
	private Boolean useApiKey = false;
	private String apiKey = null;
	
	public GoogleServiceV3(String serviceName ) {
		this.serviceName = serviceName;
	} 
	
	public String getServiceName() { return this.serviceName;}
	
	public Boolean authenticateWithClientLogin(String username, String passwd, String service) {
		this.useClientLoginAuthentication = false;
		this.clientLoginToken = null;
		
		HttpRequest req = createRequest();
		String content = 'accountType=HOSTED_OR_GOOGLE&Email='+username+'&Passwd='+passwd+'&service='+service;
		req.setEndpoint('https://www.google.com/accounts/ClientLogin');
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setMethod('POST');
		req.setBody(content);
		
		HttpResponse res = sendRequest(req);
		if (res.getStatusCode() == 200) {
			if(this.getClientLoginResponseCode(res.getBody()) == AUTH) {
				this.useClientLoginAuthentication = true;
				clientLoginToken = res.getBody().substring(res.getBody().indexOf('Auth=')+5).trim();
				System.debug('Client Login Authentication successful');
				return  true;
			} else {
				System.debug('Client Login Authentication failed. Body was: ' + res.getBody());
				return false;
			}
		}
		throw buildResponseException(res);
	}
	
	public void setApiKey(String key) {
		this.apiKey = key;
		this.useApiKey = true;
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
		if (res.getStatusCode() == 200) {
			return res.getBody();
		}
		throw buildResponseException(res);
	}
	
	private Integer getClientLoginResponseCode(String response)
	{
		if(response.contains('Auth=')) return AUTH;
		if(response.contains('BadAuthentication=')) return BAD_AUTH;
		if(response.contains('NotVerified=')) return NOT_VERIFIED;
		if(response.contains('TermsNotAgreed=')) return TERMS_NOT_AGREED;
		if(response.contains('CaptchaRequired=')) return CAPTCHA_REQUIRED;
		if(response.contains('Unknown=')) return UNKNOWN;
		if(response.contains('AccountDeleted=')) return ACCOUNT_DELETED;
		if(response.contains('AccountDisabled=')) return ACCOUNT_EXPIRED;
		if(response.contains('ServiceDisabled=')) return SERVICE_DISABLED;
		if(response.contains('ServiceUnavailable=')) return SERVICE_UNAVAILABLE;
		
		return NO_MATCH;
	}
	
	private HttpRequest createRequest() {
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		if(this.useClientLoginAuthentication) {
			req.setHeader('Authorization','GoogleLogin auth=' + this.clientLoginToken);
		}
		if (this.useApiKey) {
			req.setHeader('Authorization', 'Bearer ' + this.apiKey);
			System.debug(req.getHeader('Authorization'));
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
		return new GoogleServiceException(msg);
	}
}