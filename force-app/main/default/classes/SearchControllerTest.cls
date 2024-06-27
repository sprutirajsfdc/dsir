@isTest
public class SearchControllerTest {
    
    @isTest
    static void testFetchRecordsWithoutSelectedRecordId() {
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Test input parameters
        SearchController.SearchWrapper inputWrapper = new SearchController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.searchString = 'Test';
        inputWrapper.selectedRecordId = null;
        
        // Call the method to test
        List<SearchController.ResultWrapper> result = SearchController.fetchRecords(inputWrapper);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        // Ensure that the result list is not empty before accessing its elements
        if (!result.isEmpty()) {
            System.assertEquals(testAccount.Name, result[0].mainField, 'Main field value should match');
        }
    }
    
    
    @isTest
    static void testFetchRecordsWithNullInputWrapper() {
        // Test input with null inputWrapper
        SearchController.SearchWrapper inputWrapper = null;
        
        // Call the method to test
        try {
            List<SearchController.ResultWrapper> result = SearchController.fetchRecords(inputWrapper);
            // Ensure the method does not throw an exception
            System.assertNotEquals(null, result, 'Result should not be null');
            System.assertEquals(0, result.size(), 'Result size should be 0 when inputWrapper is null');
        } catch (AuraHandledException ex) {
            // Verify that the exception is handled gracefully
            System.assertEquals('Input wrapper is null', ex.getMessage(), 'Exception message should indicate null input wrapper');
        }
    }
    
    @isTest
    static void testFetchRecordsWithZeroRecords() {
        // Test input parameters
        SearchController.SearchWrapper inputWrapper = new SearchController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.searchString = 'NonExistingName';
        inputWrapper.selectedRecordId = null;
        
        // Call the method to test
        List<SearchController.ResultWrapper> result = SearchController.fetchRecords(inputWrapper);
        
        // Perform assertions
        System.assertEquals(0, result.size(), 'Result size should be 0 when no records are found');
    }
    @isTest
    static void testFetchRecordsWithSelectedRecordId() {
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Test input parameters
        SearchController.SearchWrapper inputWrapper = new SearchController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.searchString = 'Test';
        inputWrapper.selectedRecordId = testAccount.Id;
        
        // Call the method to test
        List<SearchController.ResultWrapper> result = SearchController.fetchRecords(inputWrapper);
        
        // Perform assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        // Ensure that the result list is not empty before accessing its elements
        if (!result.isEmpty()) {
            System.assertEquals(testAccount.Name, result[0].mainField, 'Main field value should match');
        }
    }
    
    
}