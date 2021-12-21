/**
 * Created by ahilali on 21/12/2021.
 */

@IsTest
global with sharing class AttendeesMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"name":Ahmed HILALI-ahmedhilali07@gmail.com}');
        response.setStatusCode(200);
        return response;
    }
}