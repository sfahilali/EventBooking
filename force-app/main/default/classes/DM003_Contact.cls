/**
 * Created by ahilali on 21/12/2021.
 */

public with sharing class DM003_Contact {

    /**
     * @param accountsIds
     *
     * @return List<Contact>
     */
    public static List<Contact> getContactsByAccountsIds( Set<Id> accountsIds ){
        return [SELECT Id, Name, Email FROM Contact WHERE AccountId IN :accountsIds ];
    }

}