# Google API V3 for Salesforce

This project is an api wrapper for Google API V3.  
Currently it contains only Calendar API.

## Authentication
It supports OAuth2.0 Server Flow and Service Accounts authorization.

- https://developers.google.com/accounts/docs/OAuth2WebServer
- https://developers.google.com/accounts/docs/OAuth2ServiceAccount

Unfortunately, now Apex can not sign with SHA256withRSA.  
So if you want to use Service Accounts authorization, you must prepare a sign server.

- https://github.com/shunjikonishi/sign-server

### Sample code - Server Flow authrization.
    GoogleOAuth oauth = new GoogleOAuth(
        'YOUR_CLIENT_ID.apps.googleusercontent.com',
        'YOUR_CLIENT_SECRET',
        GoogleCalendarService.SCOPE_READWRITE,//scope
        'https://c.na14.visual.force.com/apex/YOUR_REDIRECT_URI'
    );
    String loginUrl = oauth.getLoginUrl();
    //ToDo Open loginUrl and get authorization code.
    GoogleOAuth.AuthResponse auth = oauth.authenticate(code);
    
    service = new GoogleCalendarService();
    service.setAccessToken(auth.token_type, auth.access_token);

### Sample code - Service Accounts authrization.
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

