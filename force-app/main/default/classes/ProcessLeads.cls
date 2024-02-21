public class ProcessLeads implements Queueable {
    List<Id> leadIds;

    public ProcessLeads(List<Id> leadIds) {
        this.leadIds = leadIds;
    }

    public void execute(QueueableContext context) {
        for (Id leadId : leadIds) {
            BrasilAPIGet.getLeadInfo(leadId);
        }
    }
}