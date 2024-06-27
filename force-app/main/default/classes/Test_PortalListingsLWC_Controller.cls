@istest
public class Test_PortalListingsLWC_Controller {
    
    @testSetup
    public static void testData(){
        
        List<Portals_Custom__c> lstPortals = new List<Portals_Custom__c>();
        //create test data for Portals_Custom__c & pba__Listing__c
        Portals_Custom__c objPortal1 = new Portals_Custom__c(
            name = 'UK SIR Website',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal1);
        
        Portals_Custom__c objPortal2 = new Portals_Custom__c(
            name = 'Dubai SIR Website',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal2);
        //   insert objPortal1;
        
        Portals_Custom__c objPortal3 = new Portals_Custom__c(
            name = 'Rightmove UK',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal3);
        
        Portals_Custom__c objPortal4 = new Portals_Custom__c(
            name = 'Lonres',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal4);
        
        Portals_Custom__c objPortal5 = new Portals_Custom__c(
            name = 'Zoopla UK',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal5);
        
        Portals_Custom__c objPortal6 = new Portals_Custom__c(
            name = 'On The Market',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal6);
        
        Portals_Custom__c objPortal7 = new Portals_Custom__c(
            name = 'KSA Website',
            isActive__c = true,
            Publish_Listing__c = true);
        lstPortals.add(objPortal7);
        insert lstPortals;
        
        pba__Listing__c objListing = new pba__Listing__c(
            name = 'Listing 1',
            Publish_on_Dubai_SIR_Website__c = true,
            Publish_on_UK_SIR_Website__c = true,
            Publish_on_Rightmove_UK__c = false,
            Publish_on_Lonres__c = false,
            Publish_on_Zoopla_UK__c = false
        );
        insert objListing;
        
    }
    
    @istest
    public static void test1(){
        
        pba__Listing__c objListing = [select id, name from pba__Listing__c];
        system.debug('objListing from test1 = '+objListing);
        PortalListingsLWC_Controller.getAllPortals(objListing.id);
        
        PortalListingsLWC_Controller.publish_Or_Unpublish('Dubai SIR Website','Publish',objListing.id);
        
        PortalListingsLWC_Controller.publish_Or_Unpublish('Dubai SIR Website','Unpublish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Zoopla UK','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Zoopla UK','Unpublish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('KSA Website','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('KSA Website','Unpublish',objListing.id);
    }
    
    @istest
    public static void test2(){
        pba__Listing__c objListing = [select id, name from pba__Listing__c];
        system.debug('objListing from test2 = '+objListing);
        PortalListingsLWC_Controller.publish_Or_Unpublish('UK SIR Website','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('UK SIR Website','Unpublish',objListing.id);
        
        PortalListingsLWC_Controller.publish_Or_Unpublish('OnTheMarket','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('OnTheMarket','Unpublish',objListing.id);
    }
    
    @istest
    public static void test3(){
        pba__Listing__c objListing = [select id, name from pba__Listing__c];
        system.debug('objListing from test2 = '+objListing);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Rightmove UK','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Rightmove UK','Unpublish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Lonres','Publish',objListing.id);
        PortalListingsLWC_Controller.publish_Or_Unpublish('Lonres','Unpublish',objListing.id);
    }
}