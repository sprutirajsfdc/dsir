@isTest
public class AMLFileHandlerTest {   
    @isTest(SeeAllData = True)
    static void testContentDocumentInsertion() {
        // Create a test ContentVersion record
        ContentVersion contentVersion = new ContentVersion(Title = 'Test Content',
                                                           PathOnClient = 'TestPathOnClient',
                                                           VersionData = Blob.valueOf('Test Content Data'));
        insert contentVersion;
        
        // Query for the ContentDocumentId using ContentVersion
        ContentVersion queriedContentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        
        // Use the obtained ContentDocumentId
        Id contentDocumentId = queriedContentVersion.ContentDocumentId; 
        
    /*    system.debug('error------------------ ');
        //Create TEst Contact Record
        Contact ContactRecord = new Contact(LastName = 'TestContactRecord',
                                           gsir_sender_recipient__c = Null,
                                           	Do_Not_Run_Automation__c = True,
                                           ContactType__c = 'Agency',
                                            pba__CompanyName__c = 'N/A',
                                           Region__c = Null,
                                           Stage__c = Null,    
                                           	CIF__c = Null); 
        insert ContactRecord; 
        
        system.debug('error3 '+ContactRecord);
        
        
        // Create test pba__Closing__c record
        pba__Closing__c closingRecord = new pba__Closing__c(Client_Type__c = 'Individual',
                                                            AML_Rating__c = Null,
                                                            Contract_Generating_User__c = Null,
                                                            Closing_Status__c = 'Open',
                                                            TargetClosingDate__c = Date.today(),
                                                            Accounted_Date__c = Date.today(),
                                                            gsir_closing_broker_split_amount__c = 0);
        insert closingRecord;
        system.debug('Closing Inserted Sussesfully>>> '+closingRecord);
                     
        // Create test pba__Listing__c record
        pba__Listing__c listingRecord = new pba__Listing__c(Name = 'TestListingRecord',
                                                           pba__ListingType__c= 'none',
                                                            External_Listing__c = True,
                                                            	gsir_form_a_expiry__c = Null,
                                                            pba__Status__c = 'none',
                                                            CurrencyIsoCode = 'GBP'                                                           
                                                           );        
        insert listingRecord;
        system.debug('Listing Inserted Sussesfully>>> '+listingRecord);
        
      
                       
        // Create test AML__c record related to the ContentDocument
        AML__c amlRecord = new AML__c(Inquiry__c = Null,
                                      Listing__c = listingRecord.Id,
                                      Closing__c = closingRecord.Id,
                                     // Contact__c = '0037E0000182yPpQAI',//'0037E0000182yPpQAI', '0037T00000PsLEiQAN'
                                      Contact__c = con.Id ,
                                      Offer__c = Null,                                      
                                      Relationship_Type__c = 'Self',
                                      Resident__c = 'YES',
                                      AML_Type__c = 'Corporate',
                                      Role__c = 'Seller');        
        insert amlRecord; 
        system.debug('AML Inserted Sussesfully>>> '+amlRecord);

        */
        AML__c acc = [Select Id from  AML__c Where Listing__c != Null AND Closing__c != Null Limit 1 ];
        
        // Create test ContentDocumentLink record related to AML
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(ContentDocumentId = contentDocumentId,
                                                                          LinkedEntityId = acc.Id,
                                                                          ShareType = 'I',
                                                                          Visibility = 'AllUsers');
        
        // Call the AMLFileHandler method
        Test.startTest();
        insert contentDocumentLink;
        Test.stopTest();
        
   /*     // Query for created ContentDocumentLinks
       List<ContentDocumentLink> createdContentDocumentListingLinks = [SELECT Id, LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :listingRecord.Id];
       List<ContentDocumentLink> createdContentDocumentClosingLinks = [SELECT Id, LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :closingRecord.Id];
        // Verify the expected behavior listing
        System.assertEquals(1, createdContentDocumentListingLinks.size(), 'Incorrect number of createdContentDocumentListingLinks created.');
        System.assertEquals(contentDocumentId, createdContentDocumentListingLinks[0].ContentDocumentId, 'Incorrect ContentDocumentId in createdContentDocumentListingLinks.');
        System.assertEquals(listingRecord.Id, createdContentDocumentListingLinks[0].LinkedEntityId, 'Incorrect LinkedEntityId in createdContentDocumentListingLinks.');
        // Verify the expected behavior Closing
        System.assertEquals(1, createdContentDocumentClosingLinks.size(), 'Incorrect number of createdContentDocumentClosingLinks created.');
       System.assertEquals(contentDocumentId, createdContentDocumentClosingLinks[0].ContentDocumentId, 'Incorrect ContentDocumentId in createdContentDocumentClosingLinks.');
       System.assertEquals(closingRecord.Id, createdContentDocumentClosingLinks[0].LinkedEntityId, 'Incorrect LinkedEntityId in createdContentDocumentClosingLinks.');
  */ 
}
}