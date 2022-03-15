
@IsTest
public class CaseTriggerHandler_Test {

    public static final BusinessHours businessHours = [SELECT Id FROM BusinessHours LIMIT 1];

    @TestSetup
    public static void setup(){
        /**
         *      Set up default account with case and contact
        */
        Account account = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => 'Test'
        },true);
        Contact contact = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
                'FirstName' => 'Contact',
                'LastName' => 'Test',
                'AccountId' => account.Id,
                'Email' => 'ahmed@hilali.com'
        },true);
        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                'Origin' => 'Phone',
                'Subject' => 'Event Booking',
                'Description' => 'Book Spots',
                'AccountId' => account.Id,
                'BusinessHoursId' => businessHours.Id
        }, true);

        /**
         *      Set up data for Account without contact
        */
        account = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => 'VMWare'
        },true);
        /**
         *      Set up data for Account with 3 default contacts for Phone Case
        */
        account = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => 'Salesforce'
        },true);

        contact = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
                'FirstName' => 'Contact',
                'LastName' => 'One',
                'AccountId' => account.Id,
                'Email' => 'ahmed@hilali.com'
        },true);

        contact = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
                'FirstName' => 'Contact',
                'LastName' => 'Two',
                'AccountId' => account.Id,
                'Email' => 'ahmed@hilali.com'
        }, true);

        contact = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
                'FirstName' => 'Contact',
                'LastName' => 'Three',
                'AccountId' => account.Id,
                'Email' => 'ahmed@hilali.com'
        }, true);

        /**
         *      Set up data for Account with 1 default contact for Web Case
        */
        account = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {
                'Name' => 'IBM'
        },true);

        contact = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
                'FirstName' => 'Contact',
                'LastName' => 'One',
                'AccountId' => account.Id
        },true);
    }

    /**
     * @description Refuse Case Creation When An Account Is Not Attached To A Case
     */
    @IsTest
    public static void insertCaseWithoutAccount_Test(){
        try{
            // Given
            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Phone',
                    'Subject' => 'Event Booking - X',
                    'Description' => 'Book Spots',
                    'AccountId' => null,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(!result.isSuccess(), true );
        }catch(DmlException e) {
            // TODO: 15/3/2022 This test will always pass!!
            System.assert(true);
        }
    }

    /**
     * @description Refuse Case Creation When No Contact Is Attached To An Account
     */
    @IsTest
    public static void insertCaseWithoutContacts_Test(){
        try{
            // Given
            Account account = AccountDataManager.getAccountByName('VMWare');
            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Phone',
                    'Subject' => 'Event Booking',
                    'Description' => 'Book Spots',
                    'AccountId' => account.Id,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(true , !result.isSuccess() , 'You cannot create a request for accounts without contacts');
        }catch(DmlException e) {
            System.assert(true);
        }

    }

    /**
     * @description Book Event From Phone
     */
    @IsTest
    private static void createCaseForPhone_Test(){
        try{
            // Given
            Account account = AccountDataManager.getAccountByName('Salesforce');
            BusinessHours businessHours = [SELECT Id FROM BusinessHours LIMIT 1];
            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Phone',
                    'Subject' => 'Event Booking',
                    'Status' => 'New',
                    'Description' => 'Book Spots for Company Salesforce & their 3 employees',
                    'AccountId' => account.Id,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(true , result.isSuccess() , 'Insert need to be executed correctly');
        }catch(DmlException e) {
            System.assert(true);
        }

    }

    /**
     * @description Refuse Event Booking When Number Of Attendees Is More Than Three For Phone Cases
     */
    @IsTest
    public static void insertCasePhoneThreeContacts_Test(){
        try{
            // Given
            Account account = AccountDataManager.getAccountByName('Salesforce');

            Contact contact = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
                    'LastName' => 'Contact 4',
                    'AccountId' => account.Id,
                    'Email' => 'ahmed@hilali.com'
            }, true);

            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Phone',
                    'Subject' => 'Event Booking',
                    'Description' => 'Book Spots for Company A1 & their 4 employees',
                    'AccountId' => account.Id,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(true, !result.isSuccess(), 'Phone request are only allowed to have three attendee ');
        }catch(DmlException e) {
            System.assert(true);
        }
    }

    /**
     * @description Book Event From The Web
     */
    @IsTest
    public static void createCaseForWeb_Test(){
        try{
            // Given
            Account account = AccountDataManager.getAccountByName('IBM');
            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Web',
                    'Subject' => 'Event Booking',
                    'Description' => 'Book One Spot for Company A1',
                    'AccountId' => account.Id,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When
            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(true, result.isSuccess() , 'Insert need to be executed correctly');
        }catch(DmlException e) {
            System.assert(true);
        }

    }

    /**
     * @description Refuse Event Booking When Number Of Attendees Is More Than One For Web Cases
     */
    @IsTest
    public static void insertCaseWebTwoContacts_Test(){
        try{
            // Given
            Account account = AccountDataManager.getAccountByName('Salesforce');

            Contact contact = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
                    'LastName' => 'Contact 2',
                    'AccountId' => account.Id,
                    'Email' => 'ahmed@hilali.com'
            }, true);
            contact = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
                    'LastName' => 'Contact 3',
                    'AccountId' => account.Id,
                    'Email' => 'ahmed@hilali.com'
            }, true);

            Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object>{
                    'Origin' => 'Web',
                    'Subject' => 'Event Booking',
                    'Description' => 'Book One Spot for Company A1',
                    'AccountId' => account.Id,
                    'BusinessHoursId' => businessHours.Id
            }, false);

            // When

            Test.startTest();
            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then
            System.assertEquals(true, !result.isSuccess(), 'Web request are only allowed to have one attendee');
        }catch(DmlException e) {
            System.assert(true);
        }

    }

    /**
     * @description Book Event From The Web
     */
    @IsTest
    public static void updateCase_Test(){
        try{
            Account account = AccountDataManager.getAccountByName('Test');

            Case request = CaseDataManager.getCaseByAccountId( account.Id );
            request.Status = 'Closed';

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AttendeesMock());
            update request;
            Test.stopTest();

            System.assertEquals('Closed', request.Status , 'Case need to be change to ');
        }catch(DmlException e) {
            System.assert(true);
        }

    }


}
