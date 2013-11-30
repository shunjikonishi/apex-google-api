public class SignServer {
	
	private String url;
	private String paramName;
	
	private String basicAuthUsername;
	private String basicAuthPassword;
	
	public SignServer(String url) {
		this(url, 'data');
	}
	
	public SignServer(String url, String paramName) {
		this.url = url;
		this.paramName = paramName;
	}
	
	public void setBasicAuthentication(String username, String password) {
		this.basicAuthUsername = username;
		this.basicAuthPassword = password;
	}
	
	public String sign(String input) {
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		String content = paramName + '=' + EncodingUtil.urlEncode(input, 'utf-8');
		req.setEndpoint(url);
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setMethod('POST');
		req.setBody(content);
		if (this.basicAuthUsername != null && this.basicAuthPassword != null) {
			Blob auth = Blob.valueOf(basicAuthUsername + ':' + basicAuthPassword);
			String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(auth);
			req.setHeader('Authorization', authorizationHeader);
		}
		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() == 200) {
			return res.getBody();
		} else {
			throw new GoogleServiceException(res.getStatusCode() + ' ' + res.getStatus() + ', ' + res.getBody());
		}
	}
}