public class ProjectUnitsController {
    @AuraEnabled(cacheable=true)
    
    public static List<CD_Project__c> getProjects() {
        return [SELECT Id, Name,Imageurl__c, (SELECT Id, Name, CD_Unit_Number__c,CD_No_of_Beds__c,Sales_Price__c,CD_View__c,Status__c FROM Properties__r) FROM CD_Project__c WHERE Name IN (
                    'Ritz Carlton Residences Business Bay', 
                    'The Private Residences DIFC', 
                    'Zabeel Saray Villas', 
                    'Ritz Carlton Ras Al Khaimah', 
                    'Eden house Canal', 
                    'Golden Tower',
                    'Corinthia Diriyah', 
                    'The Lancelot Collection', 
                    'Cityscape', 
                    'Four Seasons Abu Dhabi at Al Maryah Island', 
                    'The Ritz Carlton Diriyah', 
                    'Knightsbridge Gate', 
                    'Raffles Jeddah', 
                    'Baccarat Diriyah', 
                    'Canal Front', 
                    'Eden Hills', 
                    'Nobu Residences', 
                    'Rouge by Baccarat', 
                    'Dubai Harbour', 
                    'One & Only Penthouses', 
                    'DMCC uptown', 
                    'Seaside Hills', 
                    'Nobu Residences Tower B', 
                    'Nobu Residences Villas', 
                    'Nobu Residences Tower A', 
                    'Baccarat Residences', 
                    'Wasl', 
                    'One & Only', 
                    'One Zaabeel', 
                    'Beach Hills Villas')];
    }
   
    
}