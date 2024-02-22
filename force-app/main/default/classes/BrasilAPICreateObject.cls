/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class BrasilAPICreateObject {
   

    public static void createLead(Map<String, Object> results, Lead lead){
        if (results != null && lead != null){
                lead.TXT_CEP__c = (String)results.get('cep');
                lead.City = (String)results.get('city');
                lead.State = (String)results.get('state');
                lead.Street = (String)results.get('street');

        }
}
}