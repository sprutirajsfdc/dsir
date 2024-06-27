public class LeadController {
 @AuraEnabled(cacheable=true)
    public static List<pba__Request__c> getProperties() {
         List<pba__Request__c> units = [
        SELECT Id, Name, InquiryType__c, pba__PropertyType__c, pba__Status__c, 
       pba_uaefields__Community_Propertyfinder__c, pba__Bedrooms_pb_min__c, 
       pba__Bedrooms_pb_max__c, pba__ListingPrice_pb_max__c, pba__ListingPrice_pb_min__c,pba_uaefields__Sub_Community_Propertyfinder__c,
       CreatedDate, LastActivityLoggedOn__c, Sharing_Rule__c
FROM pba__Request__c 
WHERE Sharing_Rule__c = 'Gulf Sothebys' 
      AND InquiryType__c IN ('Buyer', 'Tenant') 
        AND LastActivityLoggedOn__c < LAST_N_DAYS:7
      AND Owner.FirstName NOT IN ('Kevin', 'Placid', 'Gazelle', 'Benedict', 'George', 'Neil', 'Marcel', 'Rohal', 'Haydee', 'Finance', 'Chris', 'Joyce', 'Sybial')
       AND pba__Status__c IN ('Not Yet Contacted', 'Not Reachable', 'Searching', 'Viewing', 'Lost')
    ];
     System.debug('Fetched units: ' + units);
    return units;
}
//UK lead 
@AuraEnabled(cacheable=true)
public static List<pba__Request__c> getPropertiesUk() {
     List<pba__Request__c> units = [
    SELECT Id, Name, InquiryType__c, pba__PropertyType__c, pba__Status__c, 
   pba_uaefields__Community_Propertyfinder__c, pba__Bedrooms_pb_min__c, 
   pba__Bedrooms_pb_max__c, pba__ListingPrice_pb_max__c, pba__ListingPrice_pb_min__c,pba_uaefields__Sub_Community_Propertyfinder__c,
   CreatedDate, LastActivityLoggedOn__c, Sharing_Rule__c
FROM pba__Request__c 
WHERE Sharing_Rule__c = 'UK Sotheby\'s International Realty' 
  AND InquiryType__c IN ('Buyer', 'Tenant') 
    AND LastActivityLoggedOn__c < LAST_N_DAYS:7
  AND Owner.FirstName NOT IN ('Kevin', 'Placid', 'Gazelle', 'Benedict', 'George', 'Neil', 'Marcel', 'Rohal', 'Haydee', 'Finance', 'Chris', 'Joyce', 'Sybial')
   AND pba__Status__c IN ('Not Yet Contacted', 'Not Reachable', 'Searching', 'Viewing', 'Lost')
];
 System.debug('Fetched units: ' + units);
return units;
}
@AuraEnabled(cacheable=true)
    public static List<pba__Request__c> getProjects() {
        return [SELECT Id, Name FROM pba__Request__c];
    }
    @AuraEnabled(cacheable=true)
    public static List<ComboOption> getPicklistValues(String objectApiName, String fieldApiName) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectApiName);
        Schema.DescribeSObjectResult describeSObjectResult = sobjType.getDescribe();
        Schema.DescribeFieldResult fieldResult = describeSObjectResult.fields.getMap().get(fieldApiName).getDescribe();

        List<ComboOption> options = new List<ComboOption>();
        for (Schema.PicklistEntry pe : fieldResult.getPicklistValues()) {
            options.add(new ComboOption(pe.getLabel(), pe.getValue()));
        }
        return options;
    }

    public class ComboOption {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}

        public ComboOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}