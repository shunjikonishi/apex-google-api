public class GoogleCalendarList extends GoogleCalendar {

	public String summaryOverride { get; set;}
	public String colorId { get; set;}
	public String backgroundColor { get; set;}
	public String foregroundColor { get; set;}
	public Boolean hidden { get { return this.hidden == null ? false : this.hidden;} set;}
	public Boolean selected { get { return this.selected == null ? false : this.selected;} set;}
	public String accessRole { get; set;}
	public List<GoogleCalendar.Reminder> defaultReminders { get; set;}
	public Boolean primary { get { return this.primary == null ? false : this.primary;} set;} 

}