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
        // Set the body as a JSON object
        for ( Contact contact : contacts ){
            if( contacts[0] != contact ) body+= ',';
            body += '{"name":"'+ contact.Name + '-' + contact.Email  +'}';
        }
        //body += ']';
        request.setBody(body);
        HttpResponse response = http.send(request);
        return response;
    }

}