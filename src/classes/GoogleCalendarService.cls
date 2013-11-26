public class GoogleCalendarService {
	
	public static final String SCOPE_READWRITE = 'https://www.googleapis.com/auth/calendar';
	public static final String SCOPE_READONLY  = 'https://www.googleapis.com/auth/calendar.readonly';
	
	public static final String CALENDAR_URL = 'https://www.googleapis.com/calendar/v3/users/me';
	
	private GoogleServiceV3 service;
	
	public GoogleCalendarService(SignServer signServer) {
		this.service = new GoogleServiceV3(signServer);
	}
	
	public GoogleCalendarService(Blob privateKey) {
		this.service = new GoogleServiceV3(privateKey);
	}
	
	public Boolean authenticate(JWT jwt) {
		if (jwt.scope == null) {
			jwt.scope = SCOPE_READWRITE;
		}
		return service.authenticate(jwt);
	}
	
	public String getAllCalendars() {
		return service.get(CALENDAR_URL + '/calendarList');
	}
	/*
	public List<GoogleCalendar> getAllCalendars() {
		GoogleData data = service.getFeed(CalendarService.allCalendars);
		return buildCalendarList(data);
	}
	
	public List<GoogleCalendar> getOwnCalendars() {
		GoogleData data = service.getFeed(CalendarService.ownCalendars);
		return buildCalendarList(data);
	}
	
	public GoogleCalendar getCalendarByTitle(String title) {
		List<GoogleCalendar> ret = getAllCalendars();
		for (GoogleCalendar cal : ret) {
			if (cal.title.startsWith(title)) {
				return cal;
			}
		}
		return null;
	} 
	
	public List<GoogleCalendarEvent> getEvents(GoogleCalendar cal, Datetime min, Datetime max) {
		GoogleData data = service.getFeed(cal.alternate +
			'?start-min=' + GoogleData.dateTimeToString(min) +
			'&start-max=' + GoogleData.dateTimeToString(max) +
			'&orderby=starttime&singleEvents=true');
		return buildEventList(data);
	}
	
	public GoogleCalendarEvent insertEvent(GoogleCalendar cal, GoogleCalendarEvent evt) {
        return insertEvent(cal, new List<GoogleCalendarEvent>{evt}).get(0);
	}
	
	public List<GoogleCalendarEvent> insertEvent(GoogleCalendar cal, List<GoogleCalendarEvent> evtList) {
		xmldom.element feed = new xmldom.element('feed'); 
		feed.attributes.put( 'xmlns','http://www.w3.org/2005/Atom');
		feed.attributes.put( 'xmlns:batch','http://schemas.google.com/gdata/batch');
		feed.attributes.put( 'xmlns:gCal','http://schemas.google.com/gCal/2005');
		feed.attributes.put( 'xmlns:gd','http://schemas.google.com/g/2005');
		xmldom.element cat =  new xmldom.element('category');
		cat.attributes.put( 'scheme','http://schemas.google.com/g/2005#kind');
		cat.attributes.put( 'term','http://schemas.google.com/g/2005#event');
		feed.appendChild(cat);

		// build an entry for each event in the list
		integer batchid = 1;
		for (GoogleCalendarEvent e: evtList) {
			xmldom.element entry =new xmldom.element('entry'); 
			entry.appendChild( Googledata.createTextNode ( 'title', e.title) );
			entry.appendChild( Googledata.createTextNode ( 'content', e.content));
			// TODO support for recurring events
			
			// construct where
			if (e.place != null) {
				xmldom.element ewhere = new xmldom.element('gd:where');
				ewhere.attributes.put('valueString', e.place);
				entry.appendChild(ewhere);
			}
			// construct start and end times
			xmldom.element ewhen = new xmldom.element('gd:when');
			ewhen.attributes.put('startTime',GoogleData.dateTimeToString(e.startTime));
			ewhen.attributes.put('endTime',GoogleData.dateTimeToString(e.endtime));
			entry.appendChild(ewhen); 
			
			// add batch info to the element 
			xmldom.element bid = GoogleData.makeElement( 'batch:id',string.valueof( batchid ) );
			entry.appendchild( bid ); 
			xmldom.element bop =  new xmldom.element('batch:operation');
			bop.attributes.put('type','insert');
			entry.appendChild( bop );
					
			batchid++; // increment the batch counter
			
			feed.appendChild( entry ); 
		}
		
		// take the entries list, wrap in a feed
		string body = feed.toXmlString(); 
		service.makePostRequest( cal.alternate + '/batch', body );
		
		//ToDo
		//return service.responseXml.root; 
		service.responseXml.root.dumpAll();
		return evtList;
	}
	
	public void removeEvent(GoogleCalendarEvent evt) {
		remove(evt.element);
	}
	
	public void updateEvent(GoogleCalendarEvent evt) {
		if (evt.element == null) {
			throw new GoogleCalendarException('ERROR missing edit url');
		}
		string editUrl  = GoogleData.getRelLink(evt.element,'edit');
		if ( editUrl == null ) { 
			throw new GoogleCalendarException('ERROR missing edit url');
		}
		xmldom.element node = evt.element.getElementByTagName('entry');
		GoogleData.addNameSpace(node); 
		GoogleData.addAPINameSpace(node, 'xmlns:gCal','http://schemas.google.com/gCal/2005');
		string body = evt.element.toXmlString();
		system.debug( body); 
		 
		service.makePutRequest( editUrl, body);
		service.responseXml.root.dumpAll();
	}
	
	private List<GoogleCalendar> buildCalendarList(GoogleData data) {
		List<GoogleCalendar> ret = new List<GoogleCalendar>();
		for (xmldom.element el: data.entries) {
			ret.add(new GoogleCalendar(el));
		}
		return ret;
	}
	
	private List<GoogleCalendarEvent> buildEventList(GoogleData data) {
		List<GoogleCalendarEvent> ret = new List<GoogleCalendarEvent>();
		for (xmldom.element el: data.entries) {
			ret.add(new GoogleCalendarEvent(el));
		}
		return ret;
	}
	
	private void remove(xmldom.element el) {
		if (el == null) {
			throw new GoogleCalendarException('ERROR missing edit url');
		}
		string editUrl  = GoogleData.getRelLink(el, 'edit');
		if ( editUrl == null ) { 
			throw new GoogleCalendarException('ERROR missing edit url');
		}
		service.makeDeleteRequest( editUrl );
	}
	*/
}