public class GoogleCalendarEvent {
	
	
	public GoogleCalendarEvent(String t, Date d) {
		title = t;
		
		Time zero = Time.newInstance(0, 0, 0, 0);
		startTime = Datetime.newInstance(d, zero);
		endTime = Datetime.newInstance(d.addDays(1), zero);
	}
	
	public GoogleCalendarEvent(String t, Datetime start, Datetime ed) {
		title = t;
		startTime = start;
		endTime = ed;
	}
	
    public static dateTime stringTodateTime(string s) { 
       s = s.replace('T',' ');
       // since google returns this format
       // {endTime=2008-06-14T10:00:00.000-07:00
       // so, don't use the GMT version of this.
       return dateTime.valueof(s);
    }
	public GoogleCalendarEvent(xmldom.element el) {
		title = el.getValue('title');
		content = el.getValue('content');
		
		xmldom.element ewhere = el.getElementByTagName('gd:where');
		if (ewhere != null) {
			place = ewhere.attributes.get('valueString');
		}
		xmldom.element ewhen = el.getElementByTagName('gd:when');
		startTime = strToDatetime(ewhen.attributes.get('startTime'));
		endTime = strToDatetime(ewhen.attributes.get('endTime'));
		
		element = el;
	}
	
	public xmldom.element element { get; private set;}
	
	public String title { 
		get; 
		set {
			title = value;
			if (element != null) {
				setValue('title', value);
			}
		}
	}
	
	public String content { 
		get; 
		set {
			content = value;
			if (element != null) {
				setValue('content', value);
			}
		}
	}
	
	public String place { 
		get; 
		set {
			place = value;
			if (element != null) {
				setValue('gd:where', value, 'valueString');
			}
		}
	}
	
	public Datetime startTime { get; private set;}
	public Datetime endTime { get; private set;}
	
	public void setStartAndEndTime(Datetime start, Datetime ed) {
		startTime = start;
		endTime = ed;
		if (element != null) {
			setValue('gd:when', datetimeToStr(start), 'startTime');
			setValue('gd:when', datetimeToStr(ed), 'endTime');
		}
	}
	
	private void setValue(String name, String value) {
		setValue(name, value, null);
	}
	
	private void setValue(String name, String value, String attrName) {
		xmldom.element el = element.getElementByTagName(name);
		if (el == null) {
			el = new xmldom.element(name);
			element.appendChild(el);
		}
		if (attrName == null) {
			el.nodeValue = value;
		} else {
			el.attributes.put(attrName, value);
		}
	}
	
	private Datetime strToDatetime(String s) {
		s = s.replace('T', ' ');
		try {
			return Datetime.valueOf(s);
		} catch (Exception e) {
			Date d = Date.valueOf(s);
			return Datetime.newInstance(d, Time.newInstance(0, 0, 0, 0));
		}
	}
	
	private String datetimeToStr(Datetime t) {
		return String.valueOfGmt(t).replace(' ','T') + '.000Z';
	}
	
	public void dump() {
		System.debug('title: ' + title);
		System.debug('content: ' + content);
		System.debug('place: ' + place);
		System.debug('startTime: ' + startTime);
		System.debug('endTime: ' + endTime);
	}
}