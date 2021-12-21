/**
 * Created by ahilali on 14/12/2021.
 */

public with sharing class DM001_Case {

    public static Case getCaseByAccountId( Id accountId ){
        return [
                SELECT Id, Origin, Subject, Description, AccountId
                FROM Case
                WHERE AccountId = :accountId
                LIMIT 1
        ];
    }

}