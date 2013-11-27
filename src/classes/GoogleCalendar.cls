public virtual class GoogleCalendar {

	public String kind { get;}
	public String etag { get;}
	public String id { get;}
	public String summary { get; set;}
	public String description { get; set;}
	public String location { get; set;}
	public String timeZone { get; set;}
	
	public class Reminder {
		public String method { get; set;}
		public Integer minutes { get; set;}
	}
	
	public override String toString() {
		return JSON.serialize(this);
	} 	
}