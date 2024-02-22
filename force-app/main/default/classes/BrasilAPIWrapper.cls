/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class BrasilAPIWrapper {

	public String cep;
	public String state;
	public String city;
	public String neighborhood;
	public String street;
	public String service;

	
	public static BrasilAPIWrapper parse(String json) {
		return (BrasilAPIWrapper) System.JSON.deserialize(json, BrasilAPIWrapper.class);
	}
}