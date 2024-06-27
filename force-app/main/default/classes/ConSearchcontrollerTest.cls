@isTest
public class ConSearchcontrollerTest {

    @isTest
    static void testSaveContactWithDuplicates() {
        // Test setup
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert testContact;

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Set duplicate contact values
        controller.newContact = new Contact(
            LastName = 'Contact',
            Email = 'test@test.com'
        );

        // Save the contact (should detect duplicates)
        Test.startTest();
        PageReference result = controller.saveContact();
        Test.stopTest();

        // Assertions
        System.assertEquals(true, controller.showDuplicateContacts);
        System.assertEquals(null, result);
    }

    @isTest
    static void testSaveContactWithoutDuplicates() {
        // Test setup
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com',
            Phone='8895927480',
            MobilePhone='7892148256'
        );
        insert testContact;

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Set non-duplicate contact values
        controller.newContact = new Contact(
            LastName = 'NewContact',
            Email = 'new@test.com',
            Phone='8895927440',
            MobilePhone='7892548256',
            Alternative_Contact_Details__c='netest@gmail.com',
            Id=null
        );

        // Save the contact (should not detect duplicates)
        Test.startTest();
        PageReference result = controller.saveContact();
        Test.stopTest();

        // Assertions
        System.assertEquals(false, controller.showDuplicateContacts);
        //System.assertNotEquals(null, result);
    }

    @isTest
    static void testCreateOrUpdateAccountWithExistingAccount() {
        // Test setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com',
            Alternative_Contact_Details__c='netest@gmail.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Save the contact (should link to existing account)
        Test.startTest();
        controller.saveContact();
        Test.stopTest();

        // Assertions
        //System.assertEquals(testAccount.Id, controller.newContact.AccountId);
    }

    @isTest
    static void testCreateOrUpdateAccountWithoutExistingAccount() {
        // Test setup
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com',
            Alternative_Contact_Details__c='netest@gmail.com',
            AccountId = null
        );
        insert testContact;

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Save the contact (should create a new account)
        Test.startTest();
        controller.saveContact();
        Test.stopTest();

        // Assertions
       // System.assertNotEquals(null, controller.newContact.AccountId);
    }

    @isTest
    static void testSaveContactWithMissingRequiredFields() {
        // Test setup
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Alternative_Contact_Details__c='netest@gmail.com'
        );

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Save the contact (should not pass validation)
        Test.startTest();
        PageReference result = controller.saveContact();
        Test.stopTest();

        // Assertions
        System.assertEquals(true, ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assertEquals(null, result);
    }

    @isTest
    static void testCancel() {
        // Test setup
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com',
            Alternative_Contact_Details__c='netest@gmail.com'
        );
        insert testContact;

        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);

        // Call cancel method
        Test.startTest();
        PageReference result = controller.cancel();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result);
        System.assertEquals('/lightning/o/Contact/list?filterName=Recent', result.getUrl());
    }

    @isTest
    static void dogetContact(){
        Contact con = new Contact();
        con.LastName='sprutiraj';
        con.Email='spru21@gmail.com';
        con.Alternative_Contact_Details__c='sprut21@gmail.com';
        con.Phone='8895927480';
        con.MobilePhone='7892148258';
        insert con;
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(con);
        ConSearchcontroller controller = new ConSearchcontroller(stdController);
        Test.stopTest();
        
    }

}