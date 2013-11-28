public class GoogleCalendarService {
	
	public static final String SCOPE_READWRITE = 'https://www.googleapis.com/auth/calendar';
	public static final String SCOPE_READONLY  = 'https://www.googleapis.com/auth/calendar.readonly';
	
	public static final String CALENDAR_URL = 'https://www.googleapis.com/calendar/v3';
	
	private GoogleServiceV3 service;
	
	public GoogleCalendarService() {
		this.service = new GoogleServiceV3();
	}
	
	public GoogleCalendarService(SignServer signServer) {
		this.service = new GoogleServiceV3(signServer);
	}
	
	public Boolean authenticate(JWT jwt) {
		if (jwt.scope == null) {
			jwt.scope = SCOPE_READWRITE;
		}
		return service.authenticate(jwt);
	}
	
	public void setAccessToken(String tokenType, String token) {
		this.service.setAccessToken(tokenType, token);
	}
	
	////////////////////////////////////////////////
	// CalendarList
	////////////////////////////////////////////////
	public ListCalendarListResponse listCalendarList() {
		return listCalendarList(null);
	}	
	
	public ListCalendarListResponse listCalendarList(ListCalendarListOption option) {
		String url = CALENDAR_URL + '/users/me/calendarList';
		if (option != null) {
			url += option.toQuery();
		}
		String str = service.get(url);
		System.debug('listCalendarList: ' + str);
		return ((ListCalendarListResponse)JSON.deserializeStrict(str, ListCalendarListResponse.class)); 
	}

	public GoogleCalendarList getCalendarList(String id) {
		String url = CALENDAR_URL + '/users/me/calendarList/' + EncodingUtil.urlEncode(id, 'utf-8');
		String str = service.get(url);
		System.debug('getCalendarList: ' + str);
		return (GoogleCalendarList)JSON.deserializeStrict(str, GoogleCalendarList.class); 
	}

	////////////////////////////////////////////////
	// Calendar
	////////////////////////////////////////////////
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
	
	public GoogleCalendar patchCalendar(String calendarId, GoogleCalendar cal) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(calendarId, 'utf-8');
		String str = service.patch(url, cal.toString());
		System.debug('updateCalendar: ' + str);
		return (GoogleCalendar)JSON.deserializeStrict(str, GoogleCalendar.class); 
	}
	
	public void clearCalendar(String id) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(id, 'utf-8') + '/clear';
		service.post(url, '');
	}
	
	public void deleteCalendar(String id) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(id, 'utf-8');
		service.doDelete(url);
	}
	
	////////////////////////////////////////////////
	// Event
	////////////////////////////////////////////////
	public ListEventResponse listEvent(GoogleCalendar cal) {
		ListEventOption option = new ListEventOption();
		option.timeMin = Datetime.now().addYears(-1);
		return listEvent(cal, option);
	}
	
	public ListEventResponse listEvent(GoogleCalendar cal, ListEventOption option) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events' + option.toQuery();
		String str = service.get(url);
		System.debug('listEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (ListEventResponse)JSON.deserializeStrict(str, ListEventResponse.class); 
	}
	
	public GoogleCalendarEvent insertEvent(GoogleCalendar cal, GoogleCalendarEvent event) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events';
		String str = service.post(url, event.toString());
		System.debug('insertEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (GoogleCalendarEvent)JSON.deserializeStrict(str, GoogleCalendarEvent.class); 
	}
	
	public GoogleCalendarEvent quickAddEvent(GoogleCalendar cal, String text) {
		return quickAddEvent(cal, text, false);
	}
	
	public GoogleCalendarEvent quickAddEvent(GoogleCalendar cal, String text, boolean sendNotifications) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events/quickAdd' +
			'?text=' + EncodingUtil.urlEncode(text, 'utf-8');
		if (sendNotifications) {
			url += '&sendNotifications=true';
		}
		String str = service.post(url, '');
		System.debug('quickAddEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (GoogleCalendarEvent)JSON.deserializeStrict(str, GoogleCalendarEvent.class); 
	}
	
	public GoogleCalendarEvent getEvent(GoogleCalendar cal, String eventId) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events/' + EncodingUtil.urlEncode(eventId, 'utf-8');
		String str = service.get(url);
		System.debug('getEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (GoogleCalendarEvent)JSON.deserializeStrict(str, GoogleCalendarEvent.class); 
	}
	
	public GoogleCalendarEvent updateEvent(GoogleCalendar cal, GoogleCalendarEvent event) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events/' + EncodingUtil.urlEncode(event.id, 'utf-8');
		String str = service.put(url, event.toString());
		System.debug('updateEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (GoogleCalendarEvent)JSON.deserializeStrict(str, GoogleCalendarEvent.class); 
	}
	
	public GoogleCalendarEvent patchEvent(GoogleCalendar cal, String eventId, GoogleCalendarEvent event) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events/' + EncodingUtil.urlEncode(eventId, 'utf-8');
		String str = service.patch(url, event.toString());
		System.debug('patchEvent: ' + str);
		str = GoogleCalendarEvent.replaceProperties(str);
		return (GoogleCalendarEvent)JSON.deserializeStrict(str, GoogleCalendarEvent.class); 
	}
	
	public void deleteEvent(GoogleCalendar cal, String eventId) {
		deleteEvent(cal, eventId, false);
	}
	
	public void deleteEvent(GoogleCalendar cal, String eventId, boolean sendNotifications) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/events/' + EncodingUtil.urlEncode(eventId, 'utf-8');
		if (sendNotifications) {
			url += '?sendNotifications=true';
		}
		service.doDelete(url);
	}
	
	////////////////////////////////////////////////
	// ACL
	////////////////////////////////////////////////
	public void deleteAcl(GoogleCalendar cal, String ruleId) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl/' + EncodingUtil.urlEncode(ruleId, 'utf-8');
		service.doDelete(url);
	}
	
	public GoogleCalendarAcl getAcl(GoogleCalendar cal, String ruleId) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl/' + EncodingUtil.urlEncode(ruleId, 'utf-8');
		String str = service.get(url);
		System.debug('getAcl: ' + str);
		return (GoogleCalendarAcl)JSON.deserializeStrict(str, GoogleCalendarAcl.class); 
	}
	
	public GoogleCalendarAcl insertAcl(GoogleCalendar cal, GoogleCalendarAcl acl) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl';
		String str = service.post(url, acl.toString());
		System.debug('insertAcl: ' + str);
		return (GoogleCalendarAcl)JSON.deserializeStrict(str, GoogleCalendarAcl.class); 
	}
	
	public ListAclResponse listAcl(GoogleCalendar cal) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl';
		String str = service.get(url);
		System.debug('listAcl: ' + str);
		return (ListAclResponse)JSON.deserializeStrict(str, ListAclResponse.class); 
	}
	
	public GoogleCalendarAcl patchAcl(GoogleCalendar cal, String ruleId, GoogleCalendarAcl acl) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl/' + EncodingUtil.urlEncode(ruleId, 'utf-8');
		String str = service.patch(url, acl.toString());
		System.debug('patchAcl: ' + str);
		return (GoogleCalendarAcl)JSON.deserializeStrict(str, GoogleCalendarAcl.class); 
	}
	
	public GoogleCalendarAcl updateAcl(GoogleCalendar cal, GoogleCalendarAcl acl) {
		String url = CALENDAR_URL + '/calendars/' + EncodingUtil.urlEncode(cal.id, 'utf-8') + '/acl/' + EncodingUtil.urlEncode(acl.id, 'utf-8');
		String str = service.put(url, acl.toString());
		System.debug('patchAcl: ' + str);
		return (GoogleCalendarAcl)JSON.deserializeStrict(str, GoogleCalendarAcl.class); 
	}
	
	////////////////////////////////////////////////
	// Inner class
	////////////////////////////////////////////////
	public class ListCalendarListOption {
		
		public ListCalendarListOption() {
			this.maxResult = 0;
			this.showHidden = false;
		}
		
		public Integer maxResult { get; set;}
		public String minAccessRole { get; set;}
		public String nextPageToken { get; set;}
		public Boolean showHidden { get; set;}
		
		public String toQuery() {
			String ret = '';
			if (maxResult > 0) {
				ret += '&maxResult=' + maxResult;
			}
			if (minAccessRole != null) {
				ret += '&minAccessRole=' + EncodingUtil.urlEncode(minAccessRole, 'utf-8');
			}
			if (nextPageToken != null) {
				ret += '&nextPageToken=' + EncodingUtil.urlEncode(nextPageToken, 'utf-8');
			}
			if (showHidden) {
				ret += '&showHidden=true';
			}
			if (ret.length() > 0) {
				ret = '?' + ret.substring(1);
			}
			return ret;
			
		}
	}
	
	public class ListCalendarListResponse {
		public String kind { get; set;}
		public String etag { get; set;}
		public String nextPageToken { get; set;}
		public List<GoogleCalendarList> items { get; set;}
	}
	
	public class ListEventOption {
		
		public ListEventOption() {
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
	
	public class ListEventResponse {
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
	
	public class ListAclResponse {
		public String kind { get; set;}
		public String etag { get; set;}
		public String nextPageToken { get; set;}
		public List<GoogleCalendarAcl> items { get; set;}
	}
}