@isTest
public class PropertyValuationController_test {

     @isTest
    static void testGetPicklistValues() {
        // Test with valid object and field API names
        List<PicklistValuesController.ComboOption> options = PicklistValuesController.getPicklistValues('Account', 'Industry');
        System.assertNotEquals(0, options.size(), 'Options list should not be empty');
        for (PicklistValuesController.ComboOption option : options) {
            System.assertNotEquals(null, option.label, 'Option label should not be null');
            System.assertNotEquals(null, option.value, 'Option value should not be null');
        }
    }

    @isTest
    static void testGetPicklistValuesWithInvalidObjectApiName() {
        // Test with an invalid object API name
        List<PicklistValuesController.ComboOption> options = PicklistValuesController.getPicklistValues('Invalid_Object', 'Industry');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid object API name');
    }

    @isTest
    static void testGetPicklistValuesWithInvalidFieldApiName() {
        // Test with an invalid field API name
        List<PicklistValuesController.ComboOption> options = PicklistValuesController.getPicklistValues('Account', 'Name');
        System.assertEquals(0, options.size(), 'Options list should be empty for invalid field API name');
    }
  
}