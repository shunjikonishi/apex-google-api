public class GoogleCalendarEvent {

	private static final Time TIME_ZERO = Time.newInstance(0, 0, 0, 0);
		
	public GoogleCalendarEvent() {
		this.start_xx = new EventTime();
		this.end_xx = new EventTime();
	}
	
	public GoogleCalendarEvent(String title, Date start) {
		this();
		this.summary = title;
		this.start_xx.date_xx = start;
		this.end_xx.date_xx = start.addDays(1);
	}
	
	public GoogleCalendarEvent(String title, Datetime start, Datetime ed) {
		this();
		this.summary = title;
		this.start_xx.datetime_xx = start;
		this.end_xx.datetime_xx = ed;
	}
	
	public String kind { get;}
	public String etag { get;}
	public String id { get;}
	public String status { get;}
	public String htmlLink { get; set;}
	public Datetime created { get;}
	public Datetime updated { get;}
	public String summary { get; set;}
	public String description { get; set;}
	public String location { get; set;}
	public String colorId { get; set;}
	public GoogleUser creator { get;}
	public GoogleUser organizer { get;}
	public EventTime start_xx { get; set;}
	public EventTime end_xx { get; set;}
	public Boolean endTimeUnspecified { get { return this.endTimeUnspecified == null ? false : this.endTimeUnspecified;} set;}
	public List<String> recurrence { get; set;}
	public String recurringEventId { get; set;}
	public EventTime originalStartTime { get; set;}
	public String transparency { get; set;}
	public String visibility { get; set;}
	public String iCalUID { get; set;}
	public Integer sequence { get;}
	public List<Attendee> attendees { get; set;}
	public Boolean attendeesOmitted { get { return this.attendeesOmitted == null ? false : this.attendeesOmitted;} set;}
	public ExtendedProperties extendedProperties { get; set;}
	public String hangoutLink { get; set;}
	public GoogleGadget gadget { get; set;}
	public Boolean anyoneCanAddSelf { get { return this.anyoneCanAddSelf == null ? false : this.anyoneCanAddSelf;} set;}
	public Boolean guestsCanInviteOthers { get { return this.guestsCanInviteOthers == null ? false : this.guestsCanInviteOthers;} set;}
	public Boolean guestsCanModify { get { return this.guestsCanModify == null ? false : this.guestsCanModify;} set; }
	public Boolean guestsCanSeeOtherGuests { get { return this.guestsCanSeeOtherGuests == null ? false : this.guestsCanSeeOtherGuests;} set;}
	public Boolean privateCopy { get { return this.privateCopy == null ? false : this.privateCopy;} set;}
	public Boolean locked { get { return this.locked == null ? false : this.locked;} set;}
	public EventReminders reminders { get; set;}
	public EventSource source { get; set;}
	
	public Datetime startDate {
		get {
			if (this.start_xx.datetime_xx != null) {
				return this.start_xx.datetime_xx;
			} else if (this.start_xx.date_xx != null) {
				return Datetime.newInstance(this.start_xx.date_xx, TIME_ZERO);
			} else {
				return null;
			}
		}
		set {
			if (value.hour() == 0 && value.minute() == 0 && value.second() == 0 && value.millisecond() == 0) {
				this.start_xx.date_xx = value.date();
			} else {
				this.start_xx.datetime_xx = value;
			}
		}
	}
	
	public Datetime endDate {
		get {
			if (this.end_xx.datetime_xx != null) {
				return this.end_xx.datetime_xx;
			} else if (this.end_xx.date_xx != null) {
				return Datetime.newInstance(this.end_xx.date_xx, TIME_ZERO);
			} else {
				return null;
			}
		}
		set {
			if (value.hour() == 0 && value.minute() == 0 && value.second() == 0 && value.millisecond() == 0) {
				this.end_xx.date_xx = value.date();
			} else {
				this.end_xx.datetime_xx = value;
			}
		}
	}
	
	public override String toString() {
		String ret = JSON.serialize(this);
		ret = ret.replaceAll('"start_xx":', '"start":');
		ret = ret.replaceAll('"end_xx":', '"end":');
		ret = ret.replaceAll('"date_xx":', '"date":');
		ret = ret.replaceAll('"dateTime_xx":', '"dateTime":');
		ret = ret.replaceAll('"private_xx":', '"private":');
		ret = removeField(ret, 'startDate');
		ret = removeField(ret, 'endDate');
		return ret;
	}
	
	public static String replaceJson(String ret) {
		ret = ret.replaceAll('"start":', '"start_xx":');
		ret = ret.replaceAll('"end":', '"end_xx":');
		ret = ret.replaceAll('"date":', '"date_xx":');
		ret = ret.replaceAll('"dateTime":', '"dateTime_xx":');
		ret = ret.replaceAll('"private":', '"private_xx":');
		return ret;
	}
	
	private String removeField(String str, String fieldName) {
		Integer n = str.indexOf('"' + fieldName + '"');
		if (n == -1) {
			return str;
		}
		Integer n2 = str.indexOf(',', n);
		if (n2 == -1) {
			return str;
		}
		return str.substring(0, n) + str.substring(n2+1);
	}
	
	public class ExtendedProperties {
		public Map<String, String> private_xx { get; set;}
		public Map<String, String> shared { get; set;}
		
		public override String toString() {
			String ret = JSON.serialize(this);
			ret = ret.replaceAll('"private_xx":', '"private":');
			return ret;
		}
	}
	
	public class EventReminders {
		public Boolean useDefault { get { return this.useDefault == null ? false : this.useDefault;} set;}
		public List<GoogleCalendar.Reminder> reminders { get; set;}
		
		public override String toString() { 
			return JSON.serialize(this);
		}
	}
	
	public class EventSource {
		public String url { get; set;}
		public String title { get; set;}
		
		public override String toString() { 
			return JSON.serialize(this);
		}
	}

	public class EventTime {
		
		public Date date_xx { get; set;}
		public Datetime dateTime_xx { get; set;}
		public String timeZone { get; set;}
		
		public override String toString() {
			String ret = JSON.serialize(this);
			ret = ret.replaceAll('"date_xx":', '"date":');
			ret = ret.replaceAll('"dateTime_xx":', '"dateTime":');
			return ret;
		}
	}
	
	public class Attendee extends GoogleUser {
		
		public Boolean organizer { get { return this.organizer == null ? false : this.organizer;} set;}
		public Boolean resource { get { return this.resource == null ? false : this.resource;} set;}
		public Boolean optional { get { return this.optional == null ? false : this.optional;} set;}
		public String responseStatus { get; set;}
		public String comment { get; set;}
		public Integer additionalGuests { get; set;}
		
	}
	
	public class GoogleGadget {
		public String type { get; set;}
		public String title { get; set;}
		public String link { get; set;}
		public String iconLink { get; set;}
		public Integer width { get; set;}
		public Integer height { get; set;}
		public String display { get; set;}
		public Map<String, String> preferences { get; set;}
		
		public override String toString() { 
			return JSON.serialize(this);
		}
	}
	
}