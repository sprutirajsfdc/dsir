@isTest
public class Test_GetListingsDataXML_SaudiArabia {

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
		/*       
        lstPropMedia.add(objPropMed);
        
        pba__PropertyMedia__c objPropMed2 = new pba__PropertyMedia__c();
        objPropMed2.Name = 'Test Property Media 2';
        objPropMed2.pba__Title__c = 'abc2.png';
        objPropMed2.pba__Property__c = objProp.Id;
        objPropMed2.pba__Tags__c = 'EPC';
        lstPropMedia.add(objPropMed2);
        
        pba__PropertyMedia__c objPropMed3 = new pba__PropertyMedia__c();
        objPropMed3.Name = 'Test Property Media 3';
        objPropMed3.pba__Title__c = 'abc3.png';
        objPropMed3.pba__Property__c = objProp.Id;
        objPropMed3.pba__Tags__c = 'Floorplan';
        lstPropMedia.add(objPropMed3);
        insert lstPropMedia;
        */
        
        //call to GetListingsDataXML class
        GetListingsDataXML_SaudiArabia.getListingsForSaudi();
        GetListingsDataXML_SaudiArabia.fakeMethod();
    }
    
    @isTest
    public static void testMethod2(){
        //call to GetListingsDataXML class
        GetListingsDataXML_SaudiArabia.getListingsForSaudi();
    }
    
    @isTest
    public static void testMethod3(){
        GetListingsDataXML_SaudiArabia.fakeMethod();
    }
}