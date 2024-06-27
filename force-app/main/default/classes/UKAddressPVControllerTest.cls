@isTest
public class UKAddressPVControllerTest {

    @isTest
    static void testConstructor() {
       Contact testContact = new Contact();
           testContact.FirstName = 'Johne';
            testContact.LastName = 'Doee';  
        testContact.ContactType__c='Client';
        testContact.Sharing_Rule__c='Private';
       
        
        insert testContact;

        Test.setCurrentPageReference(new PageReference('/apex/yourPageName?id=' + testContact.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);

        UKAddressController controller = new UKAddressController(sc);

        // Add your assertions here to check if the controller values are set correctly
        System.assertEquals(testContact.Id, controller.currentRecordId);
        // Add more assertions for other controller properties
    }
    
    @isTest
    static void testSavePropertyValuation() {
        // Create a test Contact
        Contact testContact = new Contact();
        testContact.FirstName = 'John';
        testContact.LastName = 'Doe';  
        testContact.ContactType__c='Client';
        testContact.Sharing_Rule__c='Private';
        
        
        insert testContact;

        // Create a test UKAddressPVController instance
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        UKAddressPVController controller = new UKAddressPVController(sc);

        // Set required fields for the newPropertyValuation
        controller.SubBuilding = 'SubBuilding';
        controller.BuildingName = 'BuildingName';
        controller.BuildingNumber = 'BuildingNumber';
        controller.StreetSubcommunity = 'StreetSubcommunity';
        controller.DistrictCommunity = 'DistrictCommunity';
        controller.CityCommunity = 'CityCommunity';
        controller.ProvienceState = 'ProvienceState';
        controller.PostalCode = '12345';
        controller.country = 'United Kingdom';
        controller.PropertyfinderRegion = 'SubBuilding BuildingName BuildingNumber,StreetSubcommunity,CityCommunity,DistrictCommunity,ProvienceState,12345,United Kingdom';
        controller.showField3=true;
        controller.errorMessage='Please Select Area/Town from dropdown values';
        controller.rectype='Rent';
        controller.picklistValues = new List<SelectOption>{
    new SelectOption('Rent', 'Rent'),
    new SelectOption('Sale', 'Sale')
};
        // Set controller properties
     /*   controller.BuildingName = 'Test Building';
        controller.StreetSubcommunity = 'Test Street';
        controller.PostalCode ='100 123';
        controller.showSpinner = true;*/
        // Set other properties as needed

        // Start the spinner
        controller.startSpinner();
        controller.showField3Button();
        // Save the Property Valuation
        Test.startTest();
        controller.savePropertyValuation();
        Test.stopTest();

        // Verify if the spinner has stopped
      //  System.assertEquals(false, controller.showSpinner);

        // Add additional assertions as needed based on your implementation
    }

    // Add more test methods as needed for other functionalities in the controller
}