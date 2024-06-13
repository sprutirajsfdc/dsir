public with sharing class UnitDetailsController {
    @AuraEnabled(cacheable=true)
    public static List<OS_Property__c> getUnitDetails() {
        return [SELECT Id,Name,os_Project_Name__c,os_Project__c,os_No_of_Beds__c,os_Unit_Number__c, os_Sales_Price__c, os_View__c, os_Tower__c, os_Status__c,Total_Area_Sq_ft__c,External_Area_Sq_ft__c,Internal_Area_Sq_ft__c FROM OS_Property__c];
    }
}