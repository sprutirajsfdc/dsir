public class UKAddressPVController {
    
    public  Property_Valuation__c newPropertyValuation {get; set;}
    public  String currentRecordId {get;set;}
    public  Boolean showSpinner { get; set; }
    public  String SubBuilding {get;set;}
    public  String BuildingName {get;set;}
    public  String BuildingNumber {get;set;}
    public  String StreetSubcommunity {get;set;}
    public  String DistrictCommunity {get;set;}
    public  String CityCommunity {get;set;}
    public  String ProvienceState {get;set;}
    public  String PostalCode {get;set;}
    public  String country {get;set;}
    public  String PropertyfinderRegion{get;set;}
    public  String errorMessage { get; set; }
     public  String erMessage { get; set; }
     public  String successMessage { get; set; }
    public Boolean showField3 { get; set; }
    public String rectype{get;set;}
     public List<selectOption> picklistValues { get; set; }
    
    
    
    ApexPages.StandardController controller;
    public UKAddressPVController(ApexPages.StandardController controller) {
         
        newPropertyValuation = new Property_Valuation__c();
        this.controller = controller;
        system.debug('address:'+PropertyfinderRegion);
        system.debug('city:'+CityCommunity);    
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        
        System.debug('currentRecordId' +currentRecordId);
        picklistValues= new List<selectOption>();
        picklistValues.add(new selectOption('--None--','--None--'));
		for(RecordType rec : [select Id,Name,SobjectType,IsActive from RecordType where SobjectType='Property_Valuation__c']){
			picklistValues.add(new selectOption(rec.name,rec.Name));
            
		}
        system.debug('pick val:'+picklistValues);
    }
    public void showField3Button() {
        // Add any additional logic here if needed
        
        showField3 = true;
      
    }
  
    public void startSpinner() {
        system.debug('spinner on');
     if(rectype!='--None--' && (newPropertyValuation.Select_Ara_Town__c!=null || CityCommunity!=null)){
       if ((CityCommunity!='' && CityCommunity != 'London')||(CityCommunity == 'London' && ProvienceState!='') ){ 
        system.debug('spinner 1');
        showSpinner = true;
           System.debug('showSpinner' +showSpinner);
       }
         savePropertyValuation();
         showSpinner = false;
         System.debug('showSpinner' +showSpinner);
}
    }
    
    public void stopSpinner() {
        showSpinner = false;
    }
    public PageReference savePropertyValuation() 
    {       
       
       showSpinner = false;
         System.debug('showSpinner' +showSpinner);
        System.debug('SubBuilding' +SubBuilding);
        System.debug('BuildingName' +BuildingName);
        System.debug('BuildingNumber' +BuildingNumber);
        System.debug('StreetSubcommunity' +StreetSubcommunity);
        System.debug('DistrictCommunity' +DistrictCommunity);
        System.debug('CityCommunity' +CityCommunity);
        System.debug('ProvienceState' +ProvienceState);
        System.debug('PostalCode' +PostalCode);
        System.debug('country' +country);
        
        
        String PropertyPropertyfinder = '';
        if (!String.isBlank(BuildingNumber)) {
            PropertyPropertyfinder += BuildingNumber;
        }
        
        if (!String.isBlank(SubBuilding)) {
            if (!String.isBlank(PropertyPropertyfinder)) {
                PropertyPropertyfinder += ', ';
            }
            PropertyPropertyfinder += SubBuilding;
        }
       /* if (!String.isBlank(BuildingName)) {
    		if (!String.isBlank(PropertyPropertyfinder)) {
        		PropertyPropertyfinder += ', ';
    		}
    		PropertyPropertyfinder += BuildingName;
		}
        */
        String SubCommunityPropertyFinder = '';
        if (!String.isBlank(StreetSubcommunity)) {
            SubCommunityPropertyFinder += StreetSubcommunity;
        }
        
        if (!String.isBlank(DistrictCommunity)) {
            if (!String.isBlank(SubCommunityPropertyFinder)) {
                SubCommunityPropertyFinder += ', ';
            }
            SubCommunityPropertyFinder += DistrictCommunity;
        }
               
        String Community = '';
        if (!String.isBlank(CityCommunity)) {
            Community += CityCommunity;
        }
        
        if (!String.isBlank(ProvienceState)) {
            if (!String.isBlank(ProvienceState)) {
                Community += ', ';
            }
            Community += ProvienceState;
        }
        String varPostalcode = PostalCode;
        List<String> code = varPostalcode.split(' ');
        String firstcode ='';
        if (!code.isEmpty())
        {
            firstcode = code[0];   
        }
        
       
        System.debug('rectype:'+rectype);
        if(rectype!='--None--'){
       RecordType rec= [select Id,Name,SobjectType,IsActive from RecordType where SobjectType='Property_Valuation__c' AND Name=:rectype];
        String recid=rec.Id;
         String val=recid.right(18);
        System.debug('Val after trim:'+val.length());
        System.debug('recid after trim:'+recid.length());
        newPropertyValuation.RecordTypeId=recid;
        }
          //system.debug() ;
         
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        newPropertyValuation.Contact__c=currentRecordId;
       newPropertyValuation.House_Building_Name__c=BuildingName;
        newPropertyValuation.Apartment_House_Unit_Number__c=PropertyPropertyfinder;
        newPropertyValuation.Street__c=StreetSubcommunity;
        if(String.isBlank(CityCommunity)){
            
            system.debug('newPropertyValuation.Area_Town__c'+newPropertyValuation.Select_Ara_Town__c);
            CityCommunity=newPropertyValuation.Select_Ara_Town__c;
            newPropertyValuation.Are_Town__c=newPropertyValuation.Select_Ara_Town__c;
            system.debug('newPropertyValuation.Are_Town__c2'+newPropertyValuation.Select_Ara_Town__c);
        }
        /* if ( CityCommunity == 'London')
{
newPropertyValuation.Are_Town__c = '';
newPropertyValuation.City_County__c =CityCommunity;
}*/
        else
        {
            newPropertyValuation.Are_Town__c= CityCommunity;
            newPropertyValuation.City_County__c =ProvienceState; 
        }
        
        newPropertyValuation.Postcode__c = PostalCode;
        newPropertyValuation.Country__c = country; 
        newPropertyValuation.Street_2__c ='';
        
        system.debug('newPropertyValuation.picklistvalue'+newPropertyValuation.Select_Ara_Town__c); 
        system.debug('newPropertyValuation.Are_Town__c input value'+CityCommunity);
       
        
        if(rectype!='--None--' && (newPropertyValuation.Select_Ara_Town__c!=null || CityCommunity!=null) && ((StreetSubcommunity!='' && BuildingNumber!='') || (StreetSubcommunity=='' && BuildingNumber=='') || (StreetSubcommunity=='' && BuildingNumber!='') )&&  PropertyfinderRegion!='' ){
       System.debug('BuildingNumber' +BuildingNumber);
        System.debug('StreetSubcommunity' +StreetSubcommunity);

            if ((CityCommunity!='' && CityCommunity != 'London')||(CityCommunity == 'London' && ProvienceState!='') ){ 
           showSpinner = true;
        try {
           
                insert newPropertyValuation;
              
        } catch (Exception e) 
        {   system.debug('Hello Catch block is exeuting');
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error creating property valuation: ' + e.getMessage()));
      
        }
       } else  if ( CityCommunity == 'London' && ProvienceState==''){           
            system.debug('Hello if ( CityCommunity == London && ProvienceState==NULL) is exeuting');
             // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Area/Town cannot be london.Please Select Area/Town from Area/Town Dropdown'));
            errorMessage='Please Select Area/Town from Area/Town Dropdown';
        }  
        }
        else{
            if((newPropertyValuation.Select_Ara_Town__c==null && CityCommunity==null)){
                system.debug('Hello if ( newPropertyValuation.Select_Ara_Town__c==null && CityCommunity==null) is executing');
                errorMessage = 'Please Select Area/Town from Area/Town Dropdown';
            }
            return null;
        }
        if(newPropertyValuation != null && newPropertyValuation.Id != null) {
            
        // Navigate to the contact detail page
        PageReference contactPage = new PageReference('/lightning/r/Property_Valuation__c/' + newPropertyValuation.Id + '/view');
        contactPage.setRedirect(true);
        return contactPage;
                       
            
        }else{
            /*if ( CityCommunity == 'London' && ProvienceState==''){           
            system.debug('Hello if ( CityCommunity == London && ProvienceState==NULL) is exeuting');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Area/Town cannot be london.Please Select Area/Town from Area/Town Dropdown'));
            erMessage='Please Select Area/Town from Area/Town Dropdown';
            }*/
                return null;
        }
        
    
    
        
}
    
    

}