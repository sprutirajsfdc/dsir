public class AMLFileHandler {
    public static void handleContentDocuments(List<ContentDocumentLink> contentDocumentLinks) {
        Set<Id> contentDocumentIds = new Set<Id>();
        Set<Id> amlIds = new Set<Id>();
        Set<Id> listingIds = new Set<Id>();
        Set<Id> closingIds = new Set<Id>();
        Set<Id> ContentDocumentLinklistingIds = new Set<Id>();
        Set<Id> ContentDocumentLinkclosingIds = new Set<Id>();
        
        // Extract relevant ContentDocument and AML__c record IDs
        for (ContentDocumentLink cdl : contentDocumentLinks) {
            contentDocumentIds.add(cdl.ContentDocumentId);
            amlIds.add(cdl.LinkedEntityId);
        }
        
        if (!amlIds.isEmpty()) {
            List<AML__c> amlRecords = [SELECT Id, Listing__c, Closing__c FROM AML__c WHERE Id IN :amlIds];
            
            for (AML__c amlRecord : amlRecords) {
                if (amlRecord.Listing__c != null) {
                    listingIds.add(amlRecord.Listing__c);
                }
                
                if (amlRecord.Closing__c != null) {
                    closingIds.add(amlRecord.Closing__c);
                }
            }
            
            if (!listingIds.isEmpty()) {
                for (ContentDocumentLink link : [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :listingIds ]) {
                    ContentDocumentLinklistingIds.add(link.ContentDocumentId);
                }
            }
            
            if (!closingIds.isEmpty()) {
                for (ContentDocumentLink link : [ SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :closingIds]) {
                    ContentDocumentLinkclosingIds.add(link.ContentDocumentId);
                }
            }
        }
        
        // Use contentDocumentIds to create ContentDocumentLinks for pba__Listing__c and pba__Closing__c
        if (!contentDocumentIds.isEmpty()) {
            List<ContentDocumentLink> newContentDocumentLinks = new List<ContentDocumentLink>();
            
            // Create ContentDocumentLinks for listingIds if not already linked
            if (listingIds != null && !listingIds.isEmpty() && !ContentDocumentLinklistingIds.containsAll(contentDocumentIds)) {
                for (Id listingId : listingIds) {
                    for (Id contentDocumentId : contentDocumentIds) {
                        // Check if the ContentDocumentId has been processed
                        if (!ContentDocumentLinklistingIds.contains(contentDocumentId)) {
                            ContentDocumentLink newLink = new ContentDocumentLink();
                            newLink.ContentDocumentId = contentDocumentId;
                            newLink.LinkedEntityId = listingId;
                            newLink.ShareType = 'I';
                            newLink.Visibility = 'AllUsers';
                            newContentDocumentLinks.add(newLink);
                            ContentDocumentLinklistingIds.add(contentDocumentId);
                        }
                    }
                }
            }
            
            // Create ContentDocumentLinks for closingIds if not already linked
            if (closingIds != null && !closingIds.isEmpty() && !ContentDocumentLinkclosingIds.containsAll(contentDocumentIds)) {
                for (Id closingId : closingIds) {
                    for (Id contentDocumentId : contentDocumentIds) {
                        // Check if the ContentDocumentId has been processed
                        if (!ContentDocumentLinkclosingIds.contains(contentDocumentId)) {
                            ContentDocumentLink newLink = new ContentDocumentLink();
                            newLink.ContentDocumentId = contentDocumentId;
                            newLink.LinkedEntityId = closingId;
                            newLink.ShareType = 'I';
                            newLink.Visibility = 'AllUsers';
                            newContentDocumentLinks.add(newLink);
                            ContentDocumentLinkclosingIds.add(contentDocumentId);
                        }
                    }
                }
            }
            
            // Insert new ContentDocumentLinks if the list is not empty
                if (!newContentDocumentLinks.isEmpty()) {
                    insert newContentDocumentLinks;
                }
        } 
    }
}