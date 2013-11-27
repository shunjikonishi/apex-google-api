public virtual class GoogleUser {
	
	public String id { get;}
	public String email { get;}
	public String displayName { get;}
	public Boolean self { get { return this.self == null ? false : this.self;}}
	
	public override String toString() {
		return JSON.serialize(this);
	} 	
}