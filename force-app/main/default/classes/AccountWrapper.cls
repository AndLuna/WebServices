global  class AccountWrapper {
    public String Id {get; set;}
    public String Name { get; set; }
    public String Industry { get; set; }
    public String Phone { get; set; }
    public String Description { get; set; }
    
     public Account getAccount() {
        return new Account(
            Id = this.Id,
            Name = this.Name,
            Industry = this.Industry,
            Phone = this.Phone,
            Description = this.Description
        );
    }
}