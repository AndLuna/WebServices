@RestResource(urlMapping='/account/*')
global class AccountService {
    @HttpGet
    global static Account getAccountById(){
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substringAfter('/account/');
        Account result = [SELECT Id, Name, Phone
                          FROM Account
                          Where Id =:accountId];
        return result;
        
    }
    
   @HttpPost
    global static List<Id> post(List<AccountWrapper> accounts) {
        List<Account> accountsToInsert = new List<Account>();

        for (AccountWrapper accPayload : accounts) {
            accountsToInsert.add(accPayload.getAccount());
        }

        insert accountsToInsert;

        Map<Id, Account> accountMap = new Map<Id, Account>(accountsToInsert);
        return new List<Id>(accountMap.keySet());
    }
        /*
    {
    "accounts": [
        {
            "Name": "Conta 1",
            "Phone": "123-456-7890"
        },
        {
            "Name": "Conta 2",
            "Phone": "987-654-3210"
        }
    ]
}
    */

    
    @HttpPut
    global static Id upsertAccount() {
        String requestBody = RestContext.request.requestBody.toString();
        AccountWrapper accountWrapper = (AccountWrapper) JSON.deserialize(requestBody, AccountWrapper.class);
        Account acc = accountWrapper.getAccount();
        upsert acc;
        
        return acc.Id;
    }
    /* 
    {
  "Id": "001Dn0000138n2JIAQ",
  "Name": "sucesso",
  "Industry": null,
  "Phone": null,
  "Description": null
}
    */
    
}