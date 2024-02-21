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
    

    @HttpPatch
    global static List<Id> updateAccounts(List<AccountWrapper> accountWrappers) {
        List<Account> accountsToUpdate = new List<Account>();

        for (AccountWrapper accWrapper : accountWrappers) {
            Account acc = new Account(
                Id = accWrapper.Id,
                Name = accWrapper.Name,
                Industry = accWrapper.Industry,
                Phone = accWrapper.Phone,
                Description = accWrapper.Description
            );
            accountsToUpdate.add(acc);
        }

        update accountsToUpdate;

        return new List<Id>();
    }

    /*{
    "accountWrappers": [
        {
            "Id": "001Dn0000138n36IAA",
            "Name": "Novo Nome da Conta 1",
            "Industry": "Nova Indústria 1",
            "Phone": "999-888-7777",
            "Description": "Nova Descrição 1"
        },
        {
            "Id": "001Dn0000138n2IIAQ",
            "Name": "Novo Nome da Conta 2",
            "Industry": "Nova Indústria 2",
            "Phone": "111-222-3333",
            "Description": "Nova Descrição 2"
        }
    ]
}
 */
}