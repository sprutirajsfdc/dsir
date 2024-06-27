@isTest
public class CustomLookupTest {
    
    @isTest
    static void testSearchLookupData() {
        // Create test data (insert records of the specified object type)
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Call the method with a search key
        List<sObject> result = CustomLookup.searchLookupData('Test', 'Account');

        // Assert that the result contains the expected records
        System.assertEquals(1, result.size(), 'Search result should contain one record');
        System.assertEquals(testAccount.Id, result[0].Id, 'Search result should match the test record');
    }

    @isTest
    static void testSearchDefaultRecord() {
        // Create test data (insert a record of the specified object type)
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Call the method with the record ID
        sObject result = CustomLookup.searchDefaultRecord(testAccount.Id, 'Account');

        // Assert that the result is the expected record
        System.assertEquals(testAccount.Id, result.Id, 'Search result should match the test record');
    }
}