public class GoogleCalendar {
	
	public GoogleCalendar(xmldom.element el) {
		element = el;
	}
	
	public xmldom.element element { get; private set;}
	
	private void setValue(String name, String value) {
		xmldom.element el = element.getElementByTagName(name);
		if (el == null) {
			el = new xmldom.element(name);
			el.nodeValue = value;
			element.appendChild(el);
		} else {
			el.nodeValue = value;
		}
	}
	
	public String id {
		get { return element.getValue('id');}
	}
	
	public String title {
		get { return element.getValue('title');}
		set { setValue('title', value);}
	}
	
	public String summary {
		get { return element.getValue('summary');}
		set { setValue('summary', value);}
	}
	
	public String alternate {
		get { return GoogleData.getRelLink(element, 'alternate');}
	}
	
	public String edit {
		get { return GoogleData.getRelLink(element, 'edit');}
	}
	
	public Datetime published {
		get {
			String up = element.getValue('published');
			return up == null ? null : Datetime.valueOf(up.replace('T', ' '));
		}
	}
	    
	public string toXmlString() { 
		xmldom.element node = element.clone(); 
		node.attributes.put( 'xmlns','http://www.w3.org/2005/Atom');
   		node.attributes.put( 'xmlns:gd','http://schemas.google.com/g/2005');
   		node.attributes.put( 'xmlns:gCal','http://schemas.google.com/gCal/2005');  	
		return node.toXmlString(); 
	}
}