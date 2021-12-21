/**
 * Created by ahilali on 14/12/2021.
 */

public with sharing class DM002_Account {
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