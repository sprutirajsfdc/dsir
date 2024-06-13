public with sharing class PropertyController {
    
    @AuraEnabled(cacheable=true)
    public static List<OS_Property__c> getProperties() {
         List<OS_Property__c> units = [
        SELECT Id, os_Project_Name__c, os_Unit_Number__c, os_No_of_Beds__c, os_Sales_Price__c,Name,
               os_View__c, os_Tower__c, os_Status__c,Total_Area_Sq_ft__c,External_Area_Sq_ft__c,Internal_Area_Sq_ft__c
        FROM OS_Property__c
    ];
     System.debug('Fetched units: ' + units);
    return units;
    }
    @AuraEnabled(cacheable=true)
    public static List<os_Project__c> getProjects() {
        return [SELECT Id, Name FROM os_Project__c];
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
    @AuraEnabled(cacheable=true)
    public static List<Payment_Plan__c> getPaymentPlans() {
        return [SELECT Id, Name FROM Payment_Plan__c];
    }
}