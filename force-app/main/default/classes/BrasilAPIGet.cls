/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class BrasilAPIGet {
    @future(callout=true)
    public static void getLeadInfo(Id leadId) {
        Lead lead = [SELECT TXT_CEP__c FROM Lead WHERE Id = :leadId];
        get(lead.TXT_CEP__c, lead);
    }
    
    public static void get(String CEP, Lead lead) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        request.setEndpoint('https://brasilapi.com.br/api/cep/v1/' + CEP);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        
        try {
            response = http.send(request);
            String textBody = response.getBody();

            System.debug('API Response Status Code: ' + response.getStatusCode());
            System.debug('API Response Body: ' + textBody);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(textBody);
                
                // Atualizar os campos do novo Lead com os valores obtidos da resposta da API
                BrasilAPICreateObject.createLead(results, lead);
                
                // Atualizar o Lead no banco de dados Salesforce
                update lead;
            }

        } catch (Exception e) {
            System.debug('Exception Message: ' + e.getMessage());
            System.debug('Exception Line: ' + e.getLineNumber());
        }
    }
}