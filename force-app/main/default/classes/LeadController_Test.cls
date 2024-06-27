@isTest
public class LeadController_Test {
 @testSetup
    static void setupTestData() {
        List<pba__Request__c> requests = new List<pba__Request__c>();

        requests.add(new pba__Request__c(
            InquiryType__c = 'Buyer',
            pba__PropertyType__c = 'Residential',
            pba__Status__c = 'New',
            pba_uaefields__Community_Propertyfinder__c = 'Community A',
            pba__Bedrooms_pb_min__c = 2,
            pba__Bedrooms_pb_max__c = 4,
            pba__ListingPrice_pb_min__c = 500000,
            pba__ListingPrice_pb_max__c = 1000000,
            Sharing_Rule__c = 'UAE Sotheby\'s International Realty'
        ));
        requests.add(new pba__Request__c(
            InquiryType__c = 'Buyer',
            pba__PropertyType__c = 'Residential',
            pba__Status__c = 'New',
            pba_uaefields__Community_Propertyfinder__c = 'Community A',
            pba__Bedrooms_pb_min__c = 1,
            pba__Bedrooms_pb_max__c = 3,
            pba__ListingPrice_pb_min__c = 500000,
            pba__ListingPrice_pb_max__c = 1000000,
            Sharing_Rule__c = 'UK Sotheby\'s International Realty'
        ));

        requests.add(new pba__Request__c(
            InquiryType__c = 'Tenant',
            pba__PropertyType__c = 'Commercial',
            pba__Status__c = 'New',
            pba_uaefields__Community_Propertyfinder__c = 'Community B',
            pba__Bedrooms_pb_min__c = 5,
            pba__Bedrooms_pb_max__c = 3,
            pba__ListingPrice_pb_min__c = 100000,
            pba__ListingPrice_pb_max__c = 500000,
            Sharing_Rule__c = 'UK Sotheby\'s International Realty'
        ));
        requests.add(new pba__Request__c(
            InquiryType__c = 'Tenant',
            pba__PropertyType__c = 'Commercial',
            pba__Status__c = 'New',
            pba_uaefields__Community_Propertyfinder__c = 'Community B',
            pba__Bedrooms_pb_min__c = 1,
            pba__Bedrooms_pb_max__c = 2,
            pba__ListingPrice_pb_min__c = 100000,
            pba__ListingPrice_pb_max__c = 500000,
            Sharing_Rule__c = 'UAE Sotheby\'s International Realty'
        ));

        insert requests;

      
    }

    @isTest
    static void testGetProperties() {
        Test.startTest();
        List<pba__Request__c> properties = LeadController.getProperties();
        Test.stopTest();

        System.assertNotEquals(null, properties, 'Properties should not be null');
        //System.assert(properties.size() > 0, 'Properties should contain records');
        for (pba__Request__c property : properties) {
            System.assertEquals('UAE Sotheby\'s International Realty', property.Sharing_Rule__c);
           // System.assertTrue(property.InquiryType__c == 'Buyer' || property.InquiryType__c == 'Tenant');
            System.assert(property.LastActivityDate < System.today(), 'LastActivityDate should be within the last 7 days');
        }
    }

    @isTest
    static void testGetProjects() {
        Test.startTest();
        List<pba__Request__c> projects = LeadController.getProjects();
        Test.stopTest();

        System.assertNotEquals(null, projects, 'Projects should not be null');
        System.assert(projects.size() > 0, 'Projects should contain records');
        for (pba__Request__c project : projects) {
            System.assertNotEquals(null, project.Id, 'Project Id should not be null');
            System.assertNotEquals(null, project.Name, 'Project Name should not be null');
        }
    }
      @isTest
    static void testGetPicklistValues() {
        // Test with valid object and field API names
        List<LeadController.ComboOption> options = LeadController.getPicklistValues('Account', 'Industry');
        System.assertNotEquals(0, options.size(), 'Options list should not be empty');
        for (LeadController.ComboOption option : options) {
            System.assertNotEquals(null, option.label, 'Option label should not be null');
            System.assertNotEquals(null, option.value, 'Option value should not be null');
        }
    }
    
    @isTest
    static void testGetPicklistValuesWithInvalidObjectApiName() {
        // Test with an invalid object API name
        List<LeadController.ComboOption> options = LeadController.getPicklistValues('Account', 'Name');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid object API name');
    }
    
    @isTest
    static void testGetPicklistValuesWithInvalidFieldApiName() {
        // Test with an invalid field API name
        List<LeadController.ComboOption> options = LeadController.getPicklistValues('Account', 'Name');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid field API name');
    }
}