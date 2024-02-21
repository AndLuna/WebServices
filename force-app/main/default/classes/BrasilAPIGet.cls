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
        
      //  LogsResult_API__c integrationLog = new LogsResult_API__c();
        
        try {
            response = http.send(request);
            String textBody = response.getBody();
            
         /*   integrationLog.LogDateTime__c = Datetime.now();
            integrationLog.StatusCode__c = String.valueOf(response.getStatusCode());
            integrationLog.ResponseBody__c = textBody;*/
            
            System.debug('API Response Status Code: ' + response.getStatusCode());
            System.debug('API Response Body: ' + textBody);
            
            if (response.getStatusCode() == 200) {
                // Desserializar a resposta JSON para um mapa não tipado
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(textBody);
                
                // Atualizar os campos do novo Lead com os valores obtidos da resposta da API
                lead.TXT_CEP__c = (String)results.get('cep');
                lead.City = (String)results.get('city');
                lead.State = (String)results.get('state');
                lead.Street = (String)results.get('street');
                
                // Atualizar o Lead no banco de dados Salesforce
                update lead;
            }
            
            // Inserir o log de integração após a inserção bem-sucedida ou não
          //  insert integrationLog;
        } catch (Exception e) {
            System.debug('Exception Message: ' + e.getMessage());
            System.debug('Exception Line: ' + e.getLineNumber());
            
            // Em caso de erro, não haverá atualização do Lead, apenas do log de integração
          //  insert integrationLog;
        }
    }
}