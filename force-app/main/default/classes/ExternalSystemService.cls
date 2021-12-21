public class ExternalSystemService {

    /**
     * @description register Attendees of accounts
     * @param accountsIds Ids of all accounts that need to
     */
    @Future(Callout = true)
    public static void registerAttendees(Set<Id> accountsIds) {
        // ContactDataManager
        List<Contact> contacts = DM003_Contact.getContactsByAccountsIds(accountsIds);

        HttpResponse response = AttendeesCallouts.registerAttendees(contacts);
        // Parse the JSON response
        if (response.getStatusCode() == 200) {
            notifyAttendeeByEmail(contacts);
        } else {
            System.debug('The status code returned was not expected: ' + response.getStatusCode());
        }

    }

    /**
     * @description Notify attendee by Email
     * @param contacts
     */
    public static void notifyAttendeeByEmail(List<Contact> contacts) {

        if( !contacts.isEmpty() ){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            // Set capacity to not exceed daily email limits
            Messaging.reserveSingleEmailCapacity(contacts.size());
            for ( Contact contact : contacts){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                // Strings to hold the email addresses to which you are sending the email.
                String[] toAddresses = new String[] {contact.Email};

                // Assign the addresses for the To and CC lists to the mail object.
                mail.setToAddresses(toAddresses);

                // Specify the name used as the display name.
                mail.setSenderDisplayName('Salesforce Support');

                // Specify the subject line for your email address.
                mail.setSubject('Hi ' + contact.Name + '!');

                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);

                // Specify the text content of the email.
                mail.setPlainTextBody('Welcome ' + contact.Name + ' you have been successfully register');

                mail.setHtmlBody('Welcome ' + contact.Name + ' you have been successfully register');
                mails.add( mail );
            }

            // Send the email you have created.
            Messaging.sendEmail( mails , true );
        }

        List<Task> tasks = new List<Task>();
        for (Contact contact : contacts) {
            Task task = new Task();
            task.Subject = 'Send Email To' + contact.name;
            task.Status = 'Open';
            task.Priority = 'Normal';
            task.WhatId = contact.Id;
            tasks.add(task);
        }
        insert tasks;


    }

}
