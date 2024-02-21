public with sharing class LeadHandler {
    public static void handleLeadChanges(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        List<Id> leadIds = new List<Id>();

        for (Lead leadRecord : newLeads) {
            if (oldLeadMap != null && leadRecord.TXT_CEP__c != oldLeadMap.get(leadRecord.Id).TXT_CEP__c) {
                system.debug('atualizacao ' + leadIds.add(leadRecord.Id));
            } else if (Trigger.isInsert) {
                 /* Se a condição 'if' não for atendida e estivermos inserindo um novo lead,
                     adiciona o ID do lead à lista 'leadIds' e enfileira um job para processamento assíncrono. */
                     system.debug('Insert ' + leadIds.add(leadRecord.Id));
                     system.debug('Chamando Queueable ' + System.enqueueJob(new ProcessLeads(leadIds)));
            }
        }
        /* Se a lista de IDs de leads não estiver vazia, chama o método 'get' diretamente na classe CNPJ_Lead. */
        if (!leadIds.isEmpty()) {
            for (Id leadId : leadIds) {
                Lead lead = [SELECT TXT_CEP__c FROM Lead WHERE Id = :leadId];
                BrasilAPIGet.getLeadInfo(leadId);
            }
        }

        if (Trigger.isInsert && Trigger.isBefore) {
        }

        if (Trigger.isInsert && Trigger.isAfter) {
          //  Lead_createTask.createTask([SELECT Id, OwnerId FROM Lead WHERE Id IN :leadIds]);
        }
    }
}