public class GoogleCalendarService {
	
	public static final String SCOPE_READWRITE = 'https://www.googleapis.com/auth/calendar';
	public static final String SCOPE_READONLY  = 'https://www.googleapis.com/auth/calendar.readonly';
	
	public static final String CALENDAR_URL = 'https://www.googleapis.com/calendar/v3';
	
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
	
	public CalendarListResponse listCalendarList() {
		return listCalendarList(null);
	}	
	
	public CalendarListResponse listCalendarList(CalendarListOption option) {
		String url = CALENDAR_URL + '/users/me/calendarList';
		if (option != null) {
			boolean first = true;
			if (option.maxResult > 0) {
				url += (first ? '?' : '&');
				url += 'maxResult=' + option.maxResult;
				first = false;
			}
			if (option.minAccessRole != null) {
				url += (first ? '?' : '&');
				url += 'minAccessRole=' + option.minAccessRole;
				first = false;
			}
			if (option.nextPageToken != null) {
				url += (first ? '?' : '&');
				url += 'nextPageToken=' + option.nextPageToken;
				first = false;
			}
			if (option.showHidden) {
				url += (first ? '?' : '&');
				url += 'showHidden=true';
				first = false;
			}
		}
		String str = service.get(url);
		System.debug('listCalendarList: ' + str);
		return ((CalendarListResponse)JSON.deserializeStrict(str, CalendarListResponse.class)); 
	}

	public GoogleCalendarList getCalendarList(String id) {
		String url = CALENDAR_URL + '/users/me/calendarList/' + EncodingUtil.urlEncode(id, 'utf-8');
		String str = service.get(url);
		System.debug('getCalendarList: ' + str);
		return (GoogleCalendarList)JSON.deserializeStrict(str, GoogleCalendarList.class); 
	}

	public GoogleCalendar getCalendar(String id) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(id, 'utf-8');
		String str = service.get(url);
		System.debug('getCalendar: ' + str);
		return (GoogleCalendar)JSON.deserializeStrict(str, GoogleCalendar.class); 
	}
	
	public GoogleCalendar insertCalendar(String summary) {
		GoogleCalendar cal = new GoogleCalendar();
		cal.summary = summary;
		return insertCalendar(cal);
	}
	
	public GoogleCalendar insertCalendar(GoogleCalendar cal) {
		String url = CALENDAR_URL + '/calendars';
		String str = service.post(url, cal.toString());
		System.debug('insertCalendar: ' + str);
		return (GoogleCalendar)JSON.deserializeStrict(str, GoogleCalendar.class); 
	}
	
	public GoogleCalendar updateCalendar(GoogleCalendar cal) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8');
		String str = service.put(url, cal.toString());
		System.debug('updateCalendar: ' + str);
		return (GoogleCalendar)JSON.deserializeStrict(str, GoogleCalendar.class); 
	}
	
	public void deleteCalendar(String id) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(id, 'utf-8');
		service.doDelete(url);
	}
	
	public EventListResponse listEvent(GoogleCalendar cal, EventListOption option) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events' + option.toQuery();
		String str = service.get(url);
		str = GoogleCalendarEvent.replaceJson(str);
		System.debug('listEvent: ' + str);
		return (EventListResponse)JSON.deserializeStrict(str, EventListResponse.class); 
	}

	public class CalendarListOption {
		
		public CalendarListOption() {
			this.maxResult = 0;
			this.showHidden = false;
		}
		
		public Integer maxResult { get; set;}
		public String minAccessRole { get; set;}
		public String nextPageToken { get; set;}
		public Boolean showHidden { get; set;}
	}
	
	public class CalendarListResponse {
		public String kind { get; set;}
		public String etag { get; set;}
		public String nextPageToken { get; set;}
		public List<GoogleCalendarList> items { get; set;}
	}
	
	public class EventListOption {
		
		public EventListOption() {
			this.alwaysIncludeEmail = false;
			this.maxAttendees = 0;
			this.maxResults = 0;
			this.showDeleted = false;
			this.showHiddenInvitations = false;
			
			//Custom default
			this.orderBy = 'startTime';
			this.singleEvents = true;
		}
		
		public Boolean alwaysIncludeEmail { get; set;}
		public String iCalUID { get; set;}
		public Integer maxAttendees { get; set;}
		public Integer maxResults { get; set;}
		public String orderBy { get; set;}
		public String pageToken { get; set;}
		public String privateExtendedProperty { get; set;}
		public String q { get; set;}
		public String sharedExtendedProperty { get; set;}
		public Boolean showDeleted { get; set;}
		public Boolean showHiddenInvitations { get; set;}
		public Boolean singleEvents { get; set;}
		public Datetime timeMax { get; set;}
		public Datetime timeMin { get; set;}
		public String timeZone { get; set;}
		public Datetime updatedMin { get; set;}
		
		public String toQuery() {
			String ret = '';
			if (this.alwaysIncludeEmail) {
				ret += '&alwaysIncludeEmail=true';
			}
			if (this.iCalUID != null) {
				ret += '&iCalUID=' + EncodingUtil.urlEncode(this.iCalUID, 'utf-8');
			}
			if (this.maxAttendees > 0) {
				ret += '&maxAttendees=' + this.maxAttendees;
			}
			if (this.maxResults > 0) {
				ret += '&maxResults=' + this.maxResults;
			}
			if (this.orderBy != null) {
				ret += '&orderBy=' + EncodingUtil.urlEncode(this.orderBy, 'utf-8');
			}
			if (this.pageToken != null) {
				ret += '&pageToken=' + EncodingUtil.urlEncode(this.pageToken, 'utf-8');
			}
			if (this.privateExtendedProperty != null) {
				ret += '&privateExtendedProperty=' + EncodingUtil.urlEncode(this.privateExtendedProperty, 'utf-8');
			}
			if (this.q != null) {
				ret += '&q=' + EncodingUtil.urlEncode(this.q, 'utf-8');
			}
			if (this.sharedExtendedProperty != null) {
				ret += '&sharedExtendedProperty=' + EncodingUtil.urlEncode(this.sharedExtendedProperty, 'utf-8');
			}
			if (this.showDeleted) {
				ret += '&showDeleted=true';
			}
			if (this.showHiddenInvitations) {
				ret += '&showHiddenInvitations=true';
			}
			if (this.singleEvents) {
				ret += '&singleEvents=true';
			}
			if (this.timeMax != null) {
				ret += '&timeMax=' + EncodingUtil.urlEncode(this.timeMax.format('yyyy-MM-dd\'T\'HH:mm:ssZ'), 'utf-8');
			}
			if (this.timeMin != null) {
				ret += '&timeMin=' + EncodingUtil.urlEncode(this.timeMin.format('yyyy-MM-dd\'T\'HH:mm:ssZ'), 'utf-8');
			}
			if (this.timeZone != null) {
				ret += '&timeZone=' + EncodingUtil.urlEncode(this.timeZone, 'utf-8');
			}
			if (this.updatedMin != null) {
				ret += '&updatedMin=' + EncodingUtil.urlEncode(this.updatedMin.format('yyyy-MM-dd\'T\'HH:mm:ssZ'), 'utf-8');
			}
			if (ret.length() > 0) {
				ret = '?' + ret.substring(1);
			}
			return ret;
		}
	}
	
	public class EventListResponse {
		public String kind { get; set;}
		public String etag { get; set;}
		public String summary { get; set;}
		public String description { get; set;}
		public Datetime updated { get; set;}
		public String timeZone { get; set;}
		public String accessRole { get; set;}
		public List<GoogleCalendar.Reminder> defaultReminders { get; set;}
		public String nextPageToken { get; set;}
		public List<GoogleCalendarEvent> items { get; set;}
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