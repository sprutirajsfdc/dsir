public class PortalListingsLWC_Controller {
    
    @AuraEnabled(cacheable=true)
    public static List<PortalsWrapper> getAllPortals(Id recordId){
        
        System.debug('recordId from getAllPortals = '+recordId);
        
        List<Portals_Custom__c> lstPortals = [select id, name, isActive__c, Publish_Listing__c
                                              from Portals_Custom__c];
        
        pba__Listing__c objListing = [select id, name, Publish_on_Dubai_SIR_Website__c, Publish_on_UK_SIR_Website__c, Publish_on_Rightmove_UK__c,
                                      Publish_on_Lonres__c, Publish_on_Zoopla_UK__c, Publish_on_On_The_Market__c, Publish_on_KSA_Website__c
                                      from pba__Listing__c
                                      where id =:recordId ];                                      
        
        System.debug('lstPortals = '+lstPortals);
        
        System.debug('objListing = '+objListing);
        
        if(objListing == null || (lstPortals == null || lstPortals.size() <= 0)){
            return null;
        }
        
        
        List<PortalsWrapper> lstPortalWrapper = new List<PortalsWrapper>();
        
        for(Portals_Custom__c objPortal : lstPortals){
            PortalsWrapper objPortalWrapper = new PortalsWrapper();
            objPortalWrapper.portalId = objPortal.Id;
            objPortalWrapper.portalName = objPortal.name;
            // objPortalWrapper.portalActiveStatus = objPortal.isActive__c;
            
            if(objPortal.isActive__c){
                objPortalWrapper.PortalStatus = 'Active';
            }else{
                objPortalWrapper.PortalStatus = 'Inactive';
            }
            
            objPortalWrapper.isPublishedOnPortal = false;
            
            if(objPortal.name == 'UK SIR Website'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_UK_SIR_Website__c;
            }else if(objPortal.name == 'Dubai SIR Website'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_Dubai_SIR_Website__c;
            }else if(objPortal.name == 'Rightmove UK'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_Rightmove_UK__c;
            }else if(objPortal.name == 'Lonres'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_Lonres__c;
            }else if(objPortal.name == 'Zoopla UK'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_Zoopla_UK__c;
            }else if(objPortal.name == 'On The Market'){
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_On_The_Market__c;
                //call OTM CLASS, pass Listing recordId to the class
            //    PublishOnTheMarket.calloutSendPropertyDetails(recordId);
            }else if(objPortal.name == 'KSA Website'){
                System.debug('objPortal.name == KSA Website');
                objPortalWrapper.isPublishedOnPortal = objListing.Publish_on_KSA_Website__c;
            }
            lstPortalWrapper.add(objPortalWrapper); 
        }
        
        //enclose in try-catch : TBD
        
        System.debug('lstPortalWrapper = '+lstPortalWrapper);
        
        if(lstPortalWrapper != null && lstPortalWrapper.size() > 0){
            return lstPortalWrapper;
        }else{
            return null; 
        }
    }
    
    
    @AuraEnabled
    public static String publish_Or_Unpublish(String websiteName, String actionName, String listingRecordId){
        
        String result = 'failed';
        
        System.debug('listingRecordId = '+listingRecordId);
        if(String.isBlank(websiteName) || String.isBlank(actionName) || String.isBlank(listingRecordId)){
            return result;
        }
        
        System.debug('websiteName = '+websiteName);
        System.debug('actionName = '+actionName);
        
        pba__Listing__c objListing = [select id, name, Publish_on_Dubai_SIR_Website__c, Publish_on_UK_SIR_Website__c,
                                      Publish_on_Zoopla_UK__c, Publish_on_Rightmove_UK__c, Publish_on_Lonres__c, Publish_on_KSA_Website__c
                                      from pba__Listing__c
                                      where id =:listingRecordId ];   
        
        System.debug('objListing = '+objListing);                             
        
        if(websiteName == 'Dubai SIR Website'){
            if(actionName == 'Publish'){
                System.debug('Publish Dubai SIR Website');  
                objListing.Publish_on_Dubai_SIR_Website__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish Dubai SIR Website');  
                objListing.Publish_on_Dubai_SIR_Website__c = false;
            }
        }else if(websiteName == 'UK SIR Website'){
            if(actionName == 'Publish'){
                System.debug('Publish UK SIR Website');  
                objListing.Publish_on_UK_SIR_Website__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish UK SIR Website');  
                objListing.Publish_on_UK_SIR_Website__c = false;
            }
        }else if(websiteName == 'Rightmove UK'){
            if(actionName == 'Publish'){
                System.debug('Publish Rightmove UK');  
                objListing.Publish_on_Rightmove_UK__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish Rightmove UK');  
                objListing.Publish_on_Rightmove_UK__c = false;
            }
        }else if(websiteName == 'Lonres'){
            if(actionName == 'Publish'){
                System.debug('Publish Lonres');  
                objListing.Publish_on_Lonres__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish Lonres');  
                objListing.Publish_on_Lonres__c = false;
            }
        }else if(websiteName == 'Zoopla UK'){
            if(actionName == 'Publish'){
                System.debug('Publish Zoopla UK');  
                objListing.Publish_on_Zoopla_UK__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish Zoopla UK');  
                objListing.Publish_on_Zoopla_UK__c = false;
            }
        }else if(websiteName == 'OnTheMarket'){
            if(actionName == 'Publish'){
                System.debug('Publish OnTheMarket');  
                objListing.Publish_on_On_The_Market__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish OnTheMarket');  
                objListing.Publish_on_On_The_Market__c = false;
            }
        }else if(websiteName == 'KSA Website'){
            if(actionName == 'Publish'){
                System.debug('Publish KSA Website');  
                objListing.Publish_on_KSA_Website__c = true;
            }else if(actionName == 'Unpublish'){
                System.debug('Unpublish OnTheMarket');  
                objListing.Publish_on_KSA_Website__c = false;
            }
        }
        
        try{
            update objListing;
            System.debug('updated!');
            result = 'passed';
        }catch(Exception e){
            System.debug('error = '+e.getMessage());
        }
        return result;
    }
    
    
    public class PortalsWrapper{
        //  public String listingId;
        @AuraEnabled
        public String portalId;
        @AuraEnabled
        public String portalName;
        @AuraEnabled
        public String PortalStatus;
        @AuraEnabled
        public Boolean isPublishedOnPortal; 
    }
    
}