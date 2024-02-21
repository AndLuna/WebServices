trigger Lead on Lead (after insert, after update) {
    LeadHandler.handleLeadChanges(Trigger.new, Trigger.oldMap);
}