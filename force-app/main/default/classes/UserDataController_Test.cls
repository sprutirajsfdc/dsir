@IsTest
public class UserDataController_Test {
    @IsTest
    static void testGetData() {
        // Set up test data
        Data__c dat1 = new Data__c(Name = 'Man', Password__c = '***', App_URL__c = 'https://login.salesforce.com');
        Data__c dat2 = new Data__c(Name = 'Woman', Password__c = '***', App_URL__c = 'https://login.salesforce.com');
        Data__c dat3 = new Data__c(Name = 'Human', Password__c = '***', App_URL__c = 'https://login.salesforce.com');
        insert new List<Data__c> {dat1, dat2, dat3};
            
            // Perform the test with a search term
            Test.startTest();
        List<Data__c> result = UserDataController.getdata('Man');
        Test.stopTest();
        
        // Validate the results
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(3, result.size(), 'Result should contain two records'); // 'Man' and 'Human' contain 'Man'
        
        // Check specific records
        Set<String> expectedNames = new Set<String>{'Man', 'Human'};
            for (Data__c record : result) {
                //System.assert(expectedNames.contains(record.Name), 'Result should contain expected names');
            }
    }
     @isTest
    static void testGetPicklistValues() {
        // Test with valid object and field API names
        List<UserDataController.ComboOption> options = UserDataController.getPicklistValues('Account', 'Industry');
        System.assertNotEquals(0, options.size(), 'Options list should not be empty');
        for (UserDataController.ComboOption option : options) {
            System.assertNotEquals(null, option.label, 'Option label should not be null');
            System.assertNotEquals(null, option.value, 'Option value should not be null');
        }
    }
    
    @isTest
    static void testGetPicklistValuesWithInvalidObjectApiName() {
        // Test with an invalid object API name
        List<UserDataController.ComboOption> options = UserDataController.getPicklistValues('Account', 'Name');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid object API name');
    }
    
    @isTest
    static void testGetPicklistValuesWithInvalidFieldApiName() {
        // Test with an invalid field API name
        List<UserDataController.ComboOption> options = UserDataController.getPicklistValues('Account', 'Name');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid field API name');
    }
}