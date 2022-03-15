/**
 * Created by ahilali on 14/12/2021.
 */

public class CaseTriggerHandler extends TriggerHandler{
    // TODO: 15/3/2022 The method has a cognitive complexity of 20
    public override void beforeInsert() {
        Set<Id> accountsIds = new Set<Id>();
        for ( Case requests : (List<Case>)Trigger.new ){
            // TODO: 15/3/2022 Null check on Account id
            accountsIds.add( requests.AccountId );
        }
        Map<String,Account> accounts = AccountDataManager.getAccountsByIds_Map( accountsIds );
        // TODO: 15/3/2022 the case can be omitted 
        for ( Case request : (List<Case>)Trigger.new ){
            // TODO: 15/3/2022 REMOVE Comments
            // Testing if the content of case is null or not to avoid NPE ;)
            // TODO: 15/3/2022 I suggest using the accounts.containsKey(request.AccountId) instead
            if( request.AccountId != null && (accounts.get( request.AccountId ) != null ) ){
                Account account = accounts.get( request.AccountId );
                // TODO: 15/3/2022 Be aware of calling the size method as this will throw a QueryException the contact size is > 200
                Integer contacts = account.Contacts.size();

                if(account.Contacts.isEmpty()){
                    request.addError('You cannot create a request for accounts without contacts');
                }
                else {
                    // TODO: 15/3/2022 The bellow code does the job correctly, I believe the approach can be improved to accommodate any future changes to the logic State / Strategy (behavior)
                    String requestOrigin = request.Origin;
                    String allowedAttendee = ( requestOrigin == 'Web' )? 'one' : 'three';

                    if( (contacts >= 2 && ServiceConstants.CASE_ORIGIN_WEB.equals(requestOrigin)) || (contacts >= 4 && ServiceConstants.CASE_ORIGIN_PHONE.equals(requestOrigin)) ) {
                        request.addError( requestOrigin + ' request are only allowed to have ' + allowedAttendee +  ' attendee' );
                    }
                }
            }else {
                request.addError('You cannot create a request without attaching an account');
            }
        }

    }

    public override void beforeUpdate(){
        Set<Id> accountsIds = new Set<Id>();
        for ( Case request : ( List<Case> )Trigger.new ) {
            if (request.Status == 'Closed') {
                accountsIds.add(request.AccountId);
            }
        }
        ExternalSystemService.registerAttendees(accountsIds);
    }
}