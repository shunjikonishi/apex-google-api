public class SignServer {
	
	private String url;
	
	public SignServer(String url) {
		this.url = url;
	}
	
	public String sign(String input) {
		HttpRequest req = new HttpRequest();
		req.setHeader('User-Agent','apex-google-api');
		String content = 'data=' + EncodingUtil.urlEncode(input, 'utf-8');
		req.setEndpoint(url);
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setMethod('POST');
		req.setBody(content);
		Http http = new Http();
		HttpResponse res = http.send(req);
		return res.getBody();
	}
}