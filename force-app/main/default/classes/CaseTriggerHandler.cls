/**
 * Created by ahilali on 14/12/2021.
 */

public class CaseTriggerHandler extends TriggerHandler{
    public override void beforeInsert() {
        for ( Case request : (List<Case>)Trigger.new ){
            // Testing if the content of case is null or not to avoid NPE ;)
            if(request.AccountId != null){
                Account account = DM002_Account.getAccountById( request.AccountId );
                Integer contacts = account.Contacts.size();

                if(account.Contacts.isEmpty()){
                    request.addError('You cannot create a request for accounts without contacts');
                }
                else {
                    String requestOrigin = request.Origin;
                    String allowedAttendee = ( requestOrigin == 'Web' )? 'one' : 'three';

                    if( (contacts < 2 && requestOrigin == 'Web') || (contacts < 4 && requestOrigin == 'Phone') ) {
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