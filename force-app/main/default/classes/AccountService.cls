/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
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
    global static List<Id> post(List<AccountWrapper> accountWrappers) {
        List<Account> accountsToInsert = new List<Account>();

        for (AccountWrapper accPayload : accountWrappers) {
            accountsToInsert.add(accPayload.getAccount());
        }

        insert accountsToInsert;

        Map<Id, Account> accountMap = new Map<Id, Account>(accountsToInsert);
        return new List<Id>(accountMap.keySet());
    }

    @HttpPut
    global static void upsertAccount() {
        String requestBody = RestContext.request.requestBody.toString();
        /*No contexto de JSON.deserialize, o .class é usado para indicar o tipo para o qual os dados JSON devem ser desserializados. Quando você fornece List<Account>.class como argumento para JSON.deserialize, está indicando que os dados JSON devem ser desserializados em uma lista de objetos Account. */
        List<Account> accountsToUpsert = (List<Account>) JSON.deserialize(requestBody, List<Account>.class);
    
        upsert accountsToUpsert;
    }
    
    @HttpPatch
    global static List<String> updateAccounts(List<AccountWrapper> accountWrappers) {
        List<Account> accountsToUpdate = new List<Account>();

        for (AccountWrapper accWrapper : accountWrappers) {
            accountsToUpdate.add(accWrapper.getAccount());
        }

        update accountsToUpdate;

        List<String> response = new List<String>();
        response.add('Contas atualizadas com sucesso!');

        return response;
    }

    /*
    JSON:
    [
    {
       // "Id": "001Dn0000138n36IAA",
        "Name": "za",
        "Industry": "Nova Indústria 1",
        "Phone": "999-888-7777",
        "Description": "Nova Descrição 1"
    },
    {
       // "Id": "001Dn0000138n2IIAQ",
        "Name": "ze",
        "Industry": "Nova Indústria 2",
        "Phone": "111-222-3333",
        "Description": "Nova Descrição 2"
    }
]


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