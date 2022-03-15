/**
 * Created by ahilali on 14/12/2021.
 */

public with sharing class AttendeesCallouts {

    public static HttpResponse registerAttendees( List<Contact> contacts ){
        String webServiceURL = ServiceConstants.WEB_SERVICE_URL;
        String body = '';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint( webServiceURL );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Map<String, Object> payload = generatePayload(contacts);
        request.setBody(JSON.serialize(payload));
        // TODO: 15/3/2022 Callout exception should be handled
        HttpResponse response = http.send(request);
        return response;
    }

    private static Map<String, Object> generatePayload(List<Contact> contacts) {
        Map<String, Object> payload = new Map<String, Object>();
        List<AttendeeWrapper> attendees = new List<AttendeeWrapper>();
        for (Contact contact : contacts) {
            // TODO: 15/3/2022 this needs refactoring
            String contactName = contact.Name + '-' + contact.Email;
            payload.put('name', contactName);
            attendees.add(new AttendeeWrapper(contactName)); // Builder <= Design pattern
        }
        return payload;
    }
    class AttendeeWrapper {
        public String name;
        public AttendeeWrapper(String name) {
            this.name = name;
        }
    }
}