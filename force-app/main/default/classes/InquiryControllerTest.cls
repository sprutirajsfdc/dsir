@isTest
private class InquiryControllerTest {
  @IsTest
    static void testGetInquiries() {
        CD_Project__c project =new CD_Project__c();
        project.Name='test proejct';
        insert project;
        CD_Property__c unit = new CD_Property__c();
        unit.Name='101';
        unit.CD_Project__c=project.Id;
        insert unit;
        // Create test data
        pba__Request__c request1 = new pba__Request__c(
            pba__Status__c = 'Active',
            //Listing_Unit_Number__c = 'Unit001',
            B2B_Buyers_Agent__c = 'Agent001',
            pba_uaefields__Community_Propertyfinder__c = 'Community001',
            pba_uaefields__Sub_Community_Propertyfinder__c = 'SubCommunity001',
            Unit__c = unit.Id,
            Project__c	 = project.Id,
            Sharing_Rule__c ='Private',
            InquiryType__c = 'Buyer',
            gsir_lead_source__c = 'LeadSource001',
            pba__Bedrooms_pb_min__c = 2,
            pba__Bedrooms_pb_max__c = 4,
            pba__ListingPrice_pb_min__c = 100000,
            pba__ListingPrice_pb_max__c = 200000
        );
        
        insert request1;

        // Test with various filters
        List<pba__Request__c> inquiries = InquiryController.getInquiries(
            unit.Id, project.Id, 'Active', null, 
            'Unit001', 90000, 150000, 
            'LeadSource001', 1, 'Agent001', 
            'Community001', 'SubCommunity001', 5);
        
        //System.assert(inquiries.size() > 0);

        // Test with minimal filters
        inquiries = InquiryController.getInquiries(
            null, null, null, null, 
            null, null, null, 
            null, null, null, 
            null, null, null);
        
        System.assert(inquiries.size() > 0);

        // Test with max price and min price
        inquiries = InquiryController.getInquiries(
            null, null, null, null, 
            null, 50000, 250000, 
            null, 1, null, 
            null, null, 5);
        
        //System.assert(inquiries.size() > 0);

        // Test with agent name
        inquiries = InquiryController.getInquiries(
            null, null, null, null, 
            null, null, null, 
            null, null, 'Agent001', 
            null, null, null);
        
       // System.assert(inquiries.size() > 0);
    }
    
    @IsTest
    static void testGetStatusPicklistValues() {
        List<String> statuses = InquiryController.getStatusPicklistValues();
        System.assert(statuses != null);
    }
    
    @IsTest
    static void testGetListingTypePicklistValues() {
        List<String> listingTypes = InquiryController.getListingTypePicklistValues();
        System.assert(listingTypes != null);
    }
    
    @IsTest
    static void testGetLeadSourcePicklistValues() {
        List<String> leadSources = InquiryController.getLeadSourcePicklistValues();
        System.assert(leadSources != null);
    }
    
    // Utility method for creating mock records if needed
    private static void createMockRecords() {
        pba__Request__c request1 = new pba__Request__c(
            pba__Status__c = 'Active',
            //Listing_Unit_Number__c = 'Unit001',
            B2B_Buyers_Agent__c = 'Agent001',
            pba_uaefields__Community_Propertyfinder__c = 'Community001',
            pba_uaefields__Sub_Community_Propertyfinder__c = 'SubCommunity001',
            Unit__c = 'a1B2C3',
            //Project__r.Name = 'Project001',
            InquiryType__c = 'Buyer',
            gsir_lead_source__c = 'LeadSource001',
            pba__Bedrooms_pb_min__c = 2,
            pba__Bedrooms_pb_max__c = 4,
            pba__ListingPrice_pb_min__c = 100000,
            pba__ListingPrice_pb_max__c = 200000
        );
        
        insert request1;
    }
}