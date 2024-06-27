@isTest
public class UKAddressOfferController_Test_Class {
    @isTest
    static void testConstructor() {
        pba__Offer__c Offer = new pba__Offer__c(
            // Initialize relevant fields here
        );
        insert Offer;

        Test.setCurrentPageReference(new PageReference('/apex/yourPageName?id=' + Offer.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(Offer);

        UKAddressController controller = new UKAddressController(sc);

        // Add your assertions here to check if the controller values are set correctly
        System.assertEquals(Offer.Id, controller.currentRecordId);
        // Add more assertions for other controller properties
    }

    @isTest
    static void testUpdateAddress() {
        // Create and insert a test listing
        pba__Offer__c testOffer = new pba__Offer__c();
        testOffer.pba__Status__c = 'Active';
        insert testOffer;

        Test.setCurrentPageReference(new PageReference('/apex/yourPageName?id=' + testOffer.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testOffer);

        UKAddressOfferController controller = new UKAddressOfferController(sc);

        // Set controller properties
        controller.BuildingName = 'Test Building';
        controller.StreetSubcommunity = 'Test Street';
        controller.PostalCode ='100 123';
        controller.showSpinner = true;
        // Set other properties as needed

        Test.startTest();
        controller.updateAddress();
        controller.startSpinner();
        controller.stopSpinner();
        Test.stopTest();

        
    }
}