@isTest
public class projectStatusController_Test {
@isTest 
    Static void dogettest(){
        CD_Project__c testProject = new CD_Project__c(Name = 'Test Project');
        insert testProject;
        
        CD_Property__c testunit = new CD_Property__c();
        testunit.Name='test unit';
        testunit.CD_Project__c=testProject.id;
        insert testunit;
        ProjectStatusController controller = new ProjectStatusController(null);
        controller.selectedProjectId = testunit.Id;
        controller.selectedUnitId = 'someUnitId';
        Test.startTest();
        PageReference pageRef = controller.createRecord();
        Test.stopTest();
        
        System.assertNotEquals(null, pageRef);
        String expectedUrl = '/lightning/o/RA_Request_Form__c/new?recordTypeId=null&nooverride=1&def_lkid=someUnitId';
        //System.assertEquals(expectedUrl, pageRef.getUrl());
    }
    @isTest
    static void testFetchAvailableUnits() {
        // Create test data
        CD_Project__c testProject = new CD_Project__c(Name = 'Test Project');
        insert testProject;

        CD_Property__c testProperty = new CD_Property__c(Name = 'Test Property', CD_Project__c = testProject.Id, Status__c = 'Available');
        insert testProperty;

        ProjectStatusController controller = new ProjectStatusController(null);
        controller.selectedProjectId = testProject.Id;

        // Call the fetchAvailableUnits method
        Test.startTest();
        controller.fetchAvailableUnits();
        Test.stopTest();

        // Assert that availableUnits is not null and contains expected data
        System.assertNotEquals(null, controller.availableUnits);
        System.assertEquals(1, controller.availableUnits.size());
        System.assertEquals('Test Property', controller.availableUnits[0].unit.Name);
    }
}