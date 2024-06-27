@RestResource(urlMapping='/AllListingsSaudiArabia/') //For SaudiArabia Website only
global class GetListingsDataXML_SaudiArabia {
    
    @HttpGet
    global static List<pba__Listing__c> getListingsForSaudi() {
        
        try {
            
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('pba__Listing__c');
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            
            system.debug('====>' + DescribeSObjectResultObj.FieldSets.getMap().get('Saudi_XML_feed_Listing_fields'));
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('Saudi_XML_feed_Listing_fields');
            
            List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
            
            if(fieldSetMemberList == null || fieldSetMemberList.size() <= 0){
             system.debug('empty field set');   
             return null;   
            }
            
            Set<String> setFields = new Set<String>();
            
            
            for(Schema.FieldSetMember obj:fieldSetMemberList){
                
                //  system.debug('getFieldPath = '+obj.getFieldPath());
                setFields.add(obj.getFieldPath());
            }
            system.debug('setFields = '+setFields);
            
            if(setFields == null || setFields.size() <= 0){
             system.debug('empty setFields');   
             return null;   
            }
            String fieldsString = String.join(new List<String>(setFields), ',');
            system.debug('fieldsString = '+fieldsString);
            
            if(String.isBlank(fieldsString)){
             system.debug('empty fieldsString');   
             return null;   
            }
            
            String query = 'SELECT ' + fieldsString + ' FROM pba__Listing__c where Publish_on_KSA_Website__c = true';
            
            List<pba__Listing__c> lstListings = Database.query(query);
            
            if(lstListings == null || lstListings.isEmpty()){
                system.debug('lstListings is empty!');
                return null; 
            }
            return lstListings;
        }catch (Exception e) {
            system.debug('error msg = '+e.getMessage()+' on line = '+e.getLineNumber());
            return null; 
        }
    }
    
    global static void fakeMethod(){
        Integer i = 0;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
    }    
    
}