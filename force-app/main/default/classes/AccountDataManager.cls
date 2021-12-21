/**
 * Created by ahilali on 14/12/2021.
 */

public with sharing class AccountDataManager {
    /**
     * @description Account with Contacts By Account Id
     *
     * @param accountId
     *
     * @return Account
     */
    public static Account getAccountById( Id accountId ){
        return [SELECT Id, (SELECT Id, Name, Email FROM Contacts) FROM Account WHERE Id = :accountId LIMIT 1];
    }

    public static Map<String,Account> getAccountsByIds_Map( Set<Id> accountsIds ){
        Map<String, Account> accountsMap = new Map<String, Account>();

        for(Account account : [SELECT Id, (SELECT Id, Name, Email FROM Contacts) FROM Account WHERE Id IN :accountsIds]) {
            accountsMap.put(account.Id, account);
        }

        return accountsMap;
    }

    /**
     * @description Get Account By Name
     *
     * @param accountName
     *
     * @return Account
     */
    public static Account getAccountByName( String accountName ){
        return [SELECT Id, Name FROM Account WHERE Name = :accountName LIMIT 1];
    }

}