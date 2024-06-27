public class UKAddressOfferController {
    public String currentRecordId {get;set;}
    public List<pba__Offer__c> offerListCon {get;set;}
    public Boolean showSpinner { get; set; }
    public String SubBuilding {get;set;}
    public String BuildingName {get;set;}
    public String BuildingNumber {get;set;}
    public String StreetSubcommunity {get;set;}
    public String DistrictCommunity {get;set;}
    public String CityCommunity {get;set;}
    public String ProvienceState {get;set;}
    public String PostalCode {get;set;}
    public String country {get;set;}
    public String PropertyfinderRegion{get;set;}
   
  
    ApexPages.StandardController controller;
    public UKAddressOfferController(ApexPages.StandardController controller) {
        
        this.controller = controller;
        showSpinner = false;
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        offerListCon = [SELECT id,Address__c FROM pba__Offer__c WHERE id = :currentRecordId];
        
        for(pba__Offer__c listListing: offerListCon){
            //streetAddress = listListing.gsir_unit_number__c + ','+listListing.pba__Street_pb__c+','+ listListing.pba__City_pb__c ;
        PropertyfinderRegion = listListing.Address__c;
        }
        System.debug('currentRecordId' +currentRecordId);
    }
    
    public void updateAddress()
    {
        
        System.debug('SubBuilding' +SubBuilding);
        System.debug('BuildingName' +BuildingName);
        System.debug('BuildingNumber' +BuildingNumber);
        System.debug('StreetSubcommunity' +StreetSubcommunity);
        System.debug('DistrictCommunity' +DistrictCommunity);
        System.debug('CityCommunity' +CityCommunity);
        System.debug('ProvienceState' +ProvienceState);
        System.debug('PostalCode' +PostalCode);
        System.debug('country' +country);
        
        
        
        
        
        
        String PropertyBuildingName = '';
        if (!String.isBlank(BuildingNumber)) {
            PropertyBuildingName += BuildingNumber;
        }
        
        if (!String.isBlank(SubBuilding)) {
            if (!String.isBlank(PropertyBuildingName)) {
                PropertyBuildingName += ', ';
            }
            PropertyBuildingName += SubBuilding;
        }
        if (!String.isBlank(BuildingName)) {
            if (!String.isBlank(PropertyBuildingName)) {
                PropertyBuildingName += ', ';
            }
            PropertyBuildingName += BuildingName;
        }
        
        
        
        List<pba__Offer__c> offerList = [SELECT id FROM pba__Offer__c WHERE id =:currentRecordId ];
        List<pba__Offer__c> offerListUpdate = new List<pba__Offer__c>();  
        
        for(pba__Offer__c offer: offerList){
            
            //Uk Fields
            offer.Apartment_House_Unit_Number__c = PropertyBuildingName;
            offer.Street__c = StreetSubcommunity;
            offer.Village__c = DistrictCommunity;
            
            if ( CityCommunity == 'London')
            {
                offer.Area_Town__c = '';
                offer.City_County__c =CityCommunity;
            }
            else
            {
                offer.Area_Town__c = CityCommunity;
                offer.City_County__c =ProvienceState; 
            }
            
            offer.Postcode__c = PostalCode;
            offer.Country__c = country; 
            offer.Street_2__c ='';
           
            
            offerListUpdate.add(offer);
        }
        try
        {
            update offerListUpdate;
            
        }
        catch(Exception E)
        {
            System.debug('Exception' + E);
        }
        
        
    }
    
     public void startSpinner() {
        showSpinner = true;
    }

    public void stopSpinner() {
        showSpinner = false;
    }
}