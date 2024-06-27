@isTest
public class Test_GetMedia_ListingsXML_SaudiArabia {
    
    @isTest
    public static void testMethod1(){
        
        //create Property data - 
        
        Id recordTypeIdProperty = Schema.SObjectType.pba__Property__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        system.debug('recordTypeIdProperty = '+recordTypeIdProperty);
        
        pba__Property__c objProp = new pba__Property__c();
        objProp.RecordTypeId = recordTypeIdProperty;
        objProp.Name = 'Test Listing 1';
        insert objProp;
        
        //create Listings data - 
        pba__Listing__c objListing = new pba__Listing__c();
        objListing.Name = 'Test Listing 1';
        objListing.pba__Property__c = objProp.Id;
        objListing.Publish_on_KSA_Website__c = true;
        insert objListing;
        
        //create Property Media data - 
        List<pba__PropertyMedia__c> lstPropMedia = new List<pba__PropertyMedia__c>();
        pba__PropertyMedia__c objPropMed = new pba__PropertyMedia__c();
        objPropMed.Name = 'Test Property Media 1';
        objPropMed.pba__Title__c = 'abc.png';
        objPropMed.pba__Property__c = objProp.Id;
        insert objPropMed;
        
        //call to GetMedia_ListingsXML_SaudiArabia
        GetMedia_ListingsXML_SaudiArabia.getMediaForSaudi();
        
    }
    @isTest
    public static void testMethod2(){
        //call to GetMedia_ListingsXML_SaudiArabia class
        GetMedia_ListingsXML_SaudiArabia.getMediaForSaudi();
    }
    
    
    @isTest
    public static void testMethod3(){
        Id recordTypeIdProperty = Schema.SObjectType.pba__Property__c.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        system.debug('recordTypeIdProperty = '+recordTypeIdProperty);
        
        pba__Property__c objProp = new pba__Property__c();
        objProp.RecordTypeId = recordTypeIdProperty;
        objProp.Name = 'Test Listing 1';
        insert objProp;
        //create Listings data - 
        pba__Listing__c objListing = new pba__Listing__c();
        objListing.Name = 'Test Listing 1';
        objListing.pba__Property__c = objProp.Id;
        // objListing.Publish_on_KSA_Website__c = true;
        insert objListing;
        //call to GetMedia_ListingsXML_SaudiArabia class
        GetMedia_ListingsXML_SaudiArabia.getMediaForSaudi();
    }
    
}