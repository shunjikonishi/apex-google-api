# Google API V3 for Salesforce

This project is an api wrapper for Google API V3.  
Currently it contains only Calendar API.

## Authentication
Currently it supports only Service Accounts authorization.

- https://developers.google.com/accounts/docs/OAuth2ServiceAccount

But unfortunately, now Apex can not sign with SHA256withRSA.  
So I developed a sign server for sign.

- https://github.com/shunjikonishi/sign-server

### Sample code
    SignServer sign = new SignServer('https://YOUR-APPNAME.herokuapp.com/sign');
    service = new GoogleCalendarService(sign);
    JWT jwt = new JWT('YOUR-APPACOUNT@developer.gserviceaccount.com');
    service.authenticate(jwt);

## Calendar API

https://developers.google.com/google-apps/calendar/v3/reference/

### Implemented

- Acl
    - delete
    - get
    - insert
    - list
    - patch
    - update
- CalendarList
    - list
    - get
- Calendars
    - delete
    - get
    - insert
    - update
    - patch
    - clear
- Events
    - delete
    - get
    - list
    - insert
    - patch
    - update
    - quickAdd

### Not implemented

- CalendarList
    - delete
    - insert
    - patch
    - update
- Colors
- Events
    - import
    - instances
    - move
    - watch
- Freebusy
- Settings
- Channels


### Sample code
    List<GoogleCalendarList> calList = service.listCalendarList().items;
    GoogleCalendar cal = calList.get(0);
    
    GoogleCalendarEvent event = new GoogleCalendarEvent('Event title', Date.newInstance(2013, 11, 28));
    event.location = 'Tokyo';
    event.description = 'hahaha';
    event = service.insertEvent(cal, event);
    
    service.deleteEvent(cal, event.id);

