public with sharing class InquiryController {
    
    @AuraEnabled(cacheable=true)
    public static List<pba__Request__c> getInquiries(
        String unitId, 
    String projectName, 
    String status, 
    String listingType, 
    String listingUnitNumber, 
    Decimal minPrice, 
    Decimal maxPrice, 
    String leadsource,
    Decimal bedminPrice, 
    String agentName,
    String community,
    String subcommunity,
    Decimal bedmaxPrice
    ) {
        
        String query = 'SELECT Id, Name, pba__Status__c, Listing_Unit_Number__c, B2B_Buyers_Agent__c, pba_uaefields__Community_Propertyfinder__c, pba_uaefields__Sub_Community_Propertyfinder__c, Unit__r.Name, Project__r.Name, pba__Contact__r.Name, InquiryType__c, gsir_lead_source__c, pba__Bedrooms_pb_min__c, pba__Bedrooms_pb_max__c, pba__ListingPrice_pb_min__c, pba__ListingPrice_pb_max__c FROM pba__Request__c';
    
        List<String> whereConditions = new List<String>();
        
        if (String.isNotBlank(unitId)) {
            whereConditions.add('Unit__c = \'' + unitId + '\'');
        }
        if (String.isNotBlank(projectName)) {
            whereConditions.add('Project__r.Name LIKE \'%' + projectName + '%\'');
        }
        whereConditions.add('InquiryType__c IN (\'Buyer\', \'Tenant\')');
        if (String.isNotBlank(agentName)) {
            whereConditions.add('B2B_Buyers_Agent__c LIKE \'%' + agentName + '%\'');
        }
        if (String.isNotBlank(community)) {
            whereConditions.add('pba_uaefields__Community_Propertyfinder__c LIKE \'%' + community + '%\'');
        }
        if (String.isNotBlank(subcommunity)) {
            whereConditions.add('pba_uaefields__Sub_Community_Propertyfinder__c LIKE \'%' + subcommunity + '%\'');
        }
        if (String.isNotBlank(status)) {
            whereConditions.add('pba__Status__c = \'' + status + '\'');
        }
        if (String.isNotBlank(listingType)) {
            whereConditions.add('pba__ListingType__c = \'' + listingType + '\'');
        }
        if (String.isNotBlank(listingUnitNumber)) {
            whereConditions.add('Listing_Unit_Number__c LIKE \'%' + listingUnitNumber + '%\'');
        }
        if (String.isNotBlank(leadsource)) {
            whereConditions.add('gsir_lead_source__c = \'' + leadsource + '\'');
        }
        if (maxPrice != null) {
            whereConditions.add('pba__ListingPrice_pb_max__c <= ' + String.valueOf(maxPrice));
        }
        if (minPrice != null) {
            whereConditions.add('pba__ListingPrice_pb_min__c >= ' + String.valueOf(minPrice));
        }
        if (bedminPrice != null) {
            whereConditions.add('pba__Bedrooms_pb_min__c <= ' + String.valueOf(bedminPrice));
        }
        if (bedmaxPrice != null) {
            whereConditions.add('pba__Bedrooms_pb_max__c <= ' + String.valueOf(bedmaxPrice));
        }
        
        if (!whereConditions.isEmpty()) {
            query += ' WHERE ' + String.join(whereConditions, ' AND ');
        }
        
        query += ' LIMIT 50000';
        
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getStatusPicklistValues() {
        return getPicklistValues('pba__Request__c', 'pba__Status__c');
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getListingTypePicklistValues() {
        return getPicklistValues('pba__Request__c', 'pba__ListingType__c');
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getLeadSourcePicklistValues() {
        return getPicklistValues('pba__Request__c', 'gsir_lead_source__c');
    }
    
    // Helper method to retrieve picklist values dynamically
    private static List<String> getPicklistValues(String objectName, String fieldName) {
        List<String> picklistValues = new List<String>();
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectName);
        
        if (sobjType != null && sobjType.getDescribe().fields.getMap().containsKey(fieldName)) {
            Schema.DescribeFieldResult fieldDesc = sobjType.getDescribe().fields.getMap().get(fieldName).getDescribe();
            if (fieldDesc.isAccessible() && fieldDesc.getType() == Schema.DisplayType.Picklist) {
                List<Schema.PicklistEntry> picklistEntries = fieldDesc.getPicklistValues();
                for (Schema.PicklistEntry entry : picklistEntries) {
                    picklistValues.add(entry.getValue());
                }
            }
        }
        
        return picklistValues;
    }
}