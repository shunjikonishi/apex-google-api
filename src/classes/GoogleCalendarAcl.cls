public class GoogleCalendarAcl extends AbstractJsonObject {
	
	public GoogleCalendarAcl() {
		this.scope = new Scope();
	}
	
	public GoogleCalendarAcl(String role, String scopeType, String scopeValue) {
		this.scope = new Scope();
		this.scope.type = scopeType;
		this.scope.value = scopeValue;
		this.role = role;
	}
	
	public String kind { get;}
	public String etag { get;}
	public String id { get;}
	public Scope scope { get; private set;}
	public String role { get; set;}
	
	public class Scope {
		public String type { get; set;}
		public String value { get; set;}
	}
}