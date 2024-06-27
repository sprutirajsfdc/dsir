@RestResource(urlMapping='/AllMediaSaudiArabia/') //For SaudiArabia Website only
global class GetMedia_ListingsXML_SaudiArabia {
    
    @HttpGet
    global static List<pba__PropertyMedia__c> getMediaForSaudi() {
        try {
            // query to get Listings that have been published on KSA Website
            List<pba__Listing__c> publishedListings = [select id, pba__Property__c 
                                                       from pba__Listing__c
                                                       where Publish_on_KSA_Website__c = true];
            
            if(publishedListings == null || publishedListings.size() <= 0){
                system.debug('there r no publishedListings, no media to display!');
                return null;
            }
            
            Set<String> setOfPropertyIds = new Set<String>();
            
            for(pba__Listing__c objListing : publishedListings){
                if(String.isNotBlank(objListing.pba__Property__c)){
                    setOfPropertyIds.add(objListing.pba__Property__c); 
                }
                
            }
            system.debug('setOfPropertyIds = '+setOfPropertyIds);
            
            if(setOfPropertyIds == null || setOfPropertyIds.size() <= 0){
                system.debug('there r no setOfPropertyIds, no media to display!');
                return null;
            }
            
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('pba__PropertyMedia__c');
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            
            system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get('XML_feed_Property_Media_fields'));
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('XML_feed_Property_Media_fields');
            
            List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
            
            Set<String> setFields = new Set<String>();
            
            
            for(Schema.FieldSetMember obj:fieldSetMemberList){
                
                //  system.debug('getFieldPath = '+obj.getFieldPath());
                setFields.add(obj.getFieldPath());
            }
            system.debug('setFields = '+setFields);
            String fieldsString = String.join(new List<String>(setFields), ',');
            system.debug('fieldsString = '+fieldsString);
            String query = 'SELECT ' + fieldsString + ' FROM pba__PropertyMedia__c where pba__Property__c in :setOfPropertyIds';
            system.debug('query = '+query);
            
            List<pba__PropertyMedia__c> lstPropertyMedia = Database.query(query);
            
            if(lstPropertyMedia == null || lstPropertyMedia.isEmpty()){
                system.debug('lstPropertyMedia is empty!');
                return null; 
            }
            return lstPropertyMedia;
            
        }catch (Exception e) {
            system.debug('error msg = '+e.getMessage()+' on line = '+e.getLineNumber());
            return null; 
        }
    }
}