@istest
public class Test_triggerHandler_ContentDocLink {
    
    @testSetup 
    public static void testData(){
        
    User objUser = [select Id, name, Region__c
    				from User 
                    where Region__c = 'UK' and isActive = true limit 1];
        System.runAs(objUser){
        //Create Account
        Account  AccountObj = new Account();
        AccountObj.Name ='test';
        insert AccountObj;
        
        //Create Contact
        Contact ContactObj = new Contact();
        ContactObj.LastName ='test1';
        ContactObj.ContactType__c = 'Buyer';	
        ContactObj.AccountId = AccountObj.Id;
        
        insert ContactObj;
        
        //Create Inquiry
        pba__Request__c InquiryObj = new pba__Request__c();
        InquiryObj.RecordTypeId	='0127T000000Gr33'; //0121t0000008UkHAAU
        InquiryObj.InquiryType__c = 'Buyer';
        InquiryObj.pba__Bedrooms_pb_min__c = 4;
        InquiryObj.pba__Bedrooms_pb_max__c	 =4;
        InquiryObj.pba__ListingPrice_pb_min__c =5;
        InquiryObj.pba__ListingPrice_pb_max__c	=5;
        InquiryObj.Sharing_Rule__c = 'UK Sotheby\'s International Realty';
        
        insert InquiryObj;
            
        AML__c AMLObj = new AML__c();
        AMLObj.Company__c = AccountObj.Id;
        AMLObj.Contact__c = ContactObj.Id;
        AMLObj.Inquiry__c = InquiryObj.Id;
        AMLObj.Status__c = 'TOB Pending';
        AMLObj.RecordTypeId = '0127T000000scUq';
        AMLObj.Role__c = 'Buyer';
        AMLObj.AML_Type__c = 'Individual';
        AMLObj.Upload_Passport__c = 'Yes';
        insert AMLObj;    
        /*
        AML__c AMLObj = new AML__c();
        AMLObj.Company__c = AccountObj.Id;
        AMLObj.Contact__c = ContactObj.Id;
        AMLObj.Inquiry__c = InquiryObj.Id;
        AMLObj.AML_Type__c = 'Individual';
        AMLObj.Status__c = 'Draft';
        AMLObj.Role__c = 'Buyer';
        AMLObj.AML_Type__c = 'Individual';
        AMLObj.Upload_Passport__c = 'Yes';
        insert AMLObj;
            */
        } 
     // AMLObj.Status__c = 'Compliance Review';
     // update AMLObj;
        /*
        AMLObj.Status__c = 'Compliance Review';
        update AMLObj;
        */
        /*
        AMLObj.Status__c = 'Document Pending';
        update AMLObj;
        */
        
    }
    
    @istest
    public static void test1(){
        Account  AccountObj = [select id from Account];
        Contact  ContactObj = [select id from Contact];
        pba__Request__c  InquiryObj = [select id from pba__Request__c];
        
        AML__c  AMLObj = [select id from AML__c];
        /*
        AML__c AMLObj = new AML__c();
        AMLObj.Company__c = AccountObj.Id;
        AMLObj.Contact__c = ContactObj.Id;
        AMLObj.Inquiry__c = InquiryObj.Id;
        AMLObj.Status__c = 'TOB Pending';
        AMLObj.RecordTypeId = '0127T000000scUq';
        AMLObj.Role__c = 'Buyer';
        AMLObj.AML_Type__c = 'Individual';
        AMLObj.Upload_Passport__c = 'Yes';
        insert AMLObj;
        */
        
        ContentVersion ContentVer = new ContentVersion();
        ContentVer.Title = 'Passport';
        ContentVer.ContentUrl= 'test.com';
        insert ContentVer;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument ];
        ContentDocumentLink contDoc = new ContentDocumentLink();
        contDoc.LinkedEntityId = AMLObj.id;
        contDoc.ShareType='V';
        contDoc.ContentDocumentId =[SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ContentVer.Id].ContentDocumentId;
        contDoc.Visibility='AllUsers';
        insert contDoc;   
        
    }
    
    @istest
    public static void test2(){
        triggerHandler_ContentDocLink.fakeMethod();
    }
}