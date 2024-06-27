import { LightningElement, api, wire ,track} from 'lwc';
import { getObjectInfo} from 'lightning/uiObjectInfoApi';
import PROPERTY_VALUATION_OBJECT from '@salesforce/schema/Property_Valuation__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPicklistValues from '@salesforce/apex/PicklistValuesController.getPicklistValues';
import { NavigationMixin } from 'lightning/navigation';



export default class SearchAPIAddress extends NavigationMixin(LightningElement){
    @api recordId;
    @api objectAPIName;
     @api contactId;
    strStreet;
    strState = '';
    strCity;
    strState;
    strCountry;
    strPostalCode;
    recordTypeOptions = [];
    recordTypeId;
    strAreaTown;
    strUnit;
    doorNumber;
    housename;
    town;
    build;
    strBuild;
    selectarea;
    areatown;
    @track statusOptions;
    error;  
 

    @wire(getObjectInfo, { objectApiName: PROPERTY_VALUATION_OBJECT })
    propertyValuationInfo({ error, data }) {
        if (data) {
            this.recordTypeOptions = Object.keys(data.recordTypeInfos).map(key => ({
                label: data.recordTypeInfos[key].name,
                value: key
            })).filter(option => !data.recordTypeInfos[option.value].master);
            console.log('this.recordTypeOptions'+JSON.stringify(this.recordTypeOptions));
        } else if (error) {
            console.error('Error fetching object info:', error);
        }
    }
 @wire(getPicklistValues, { objectApiName: 'Property_Valuation__c', fieldApiName: 'Select_Area_Town__c'})
  Handler({ error, data }) {
        if (data) {
            this. statusOptions = data;
            console.log('Status dtaa>>>'+data);
        } else if (error) {
            console.error('Error fetching type options:', error);
        }
    }


    handleRecordTypeChange(event) {
         if(event.detail.value) {
            this.recordTypeId = event.detail.value;
            console.log('Selected record type: ' + JSON.stringify(this.recordTypeId));
            this.recordTypeSelected = true;
        } else {
            // Custom validation: Display a toast message if no record type is selected
            this.recordTypeSelected = false;
            this.showToast('Error', 'Please select a record type.', 'error');
        }
        // this.recordTypeId = event.detail.value;
        // console.log('hi'+JSON.stringify(this.recordTypeId));
        // this.recordTypeSelected=true;
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    handleSuccess(event) {
        console.log('Created Record Id is ', event.detail.id);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Successful Record Creation',
                message: 'Property Valuation Record Created Successfully!!!',
                variant: 'success'
            })
        );
        this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: event.detail.id,
            actionName: 'view'
        }
    });
    }
    handleSubmit(event) {
        event.preventDefault(); // Prevent default submit
        console.log('okay');
        if (!this.recordTypeId) {
        // If record type is not selected, display a toast message
        this.showToast('Error', 'Please select a record type.', 'error');
        return;
    }
        
       // const fields = event.detail.fields;
      //  console.log('event'+JSON.stringify(event));
       let fields={
           "Street__c":"",
            "City_County__c":"",
            "State_proviance__c":"",
            "Country__c":"",
            "Apartment_House_Unit_Number__c":"",
            "Contact__c":"",
            "Select_Area_Town__c":"",
            "RecordTypeId":"",
            "House_Building_Name__c":"",
            "Postcode__c":"",
            "Are_Town__c":""
       };
        this.setFields(fields);
       // this.template.querySelector("lightning-record-edit-form").submit(fields);
    }

   setFields(fields) {
        //event.preventDefault();
        //const fields = event.detail.fields;
        fields.Street__c = this.strStreet;
        fields.City_County__c = this.strCity;
        fields.State_proviance__c = this.strState;
        fields.Country__c = this.strCountry;
        fields.Apartment_House_Unit_Number__c= this.strUnit;
        fields.Are_Town__c	 = this.areatown;
        fields.Postcode__c = this.strPostalCode;
        fields.House_Building_Name__c = this.housename;
        fields.RecordTypeId = this.recordTypeId;
        fields.Select_Area_Town__c=this.selectarea;
       if (this.recordId) {
            fields.Contact__c = this.recordId;
            console.log('Assigning Contact ID:', this.recordId);
        } else {
            console.log('No Contact ID Provided');
        }
        this.template.querySelector("lightning-record-edit-form").submit(fields);
    }

  


 addressInputChange(event) {
      const fullAddress = event.target.street + ", " + event.target.city + ", " + event.target.postalCode + ", " + event.target.country;
    
    this.doorNumber = this.extractDoorNumber(fullAddress);
    console.log('this.doorNumber',this.doorNumber);
    // this.town = this.extractAreaTown(fullAddress);
    
    console.log('this.town',this.town);
    console.log('Original street:', event.target.street);
     let street = event.target.street;
     street = street.replace(/\d+/g, '').trim();
    this.strStreet = street;
    console.log('Modified street:', street);
    this.strCity = event.target.city;
    this.strState = event.target.province;
    this.strCountry = event.target.country;
    this.strPostalCode = event.target.postalCode;

    // Populate Are_Town__c with the value of Street__c
    this.strAreaTown = this.strStreet;
    this.strUnit = this.doorNumber;
}

    // extractAreaTown(address) {
    //     const parts = address.split(',');
    //     if (parts.length >= 1) {
    //         return parts[0].replace(/\d+/g, '').trim();
    //     } else {
    //         return '';
    //     }
    // }
    
    extractDoorNumber(address) {
        const doorNumberPattern = /\b\d+\b/;
        const match = address.match(doorNumberPattern);
        if (match) {
            return match[0];
        } else {
            return '';
        }
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        const value = event.target.value;

        if (fieldName === 'areaTown') {
            this.strAreaTown = value;
        } else if (fieldName === 'unit') {
            this.strUnit = value;
        }
    }
     handleStatusSelect(event) {
        this.selectarea = event.detail.value;
    }
    handleInputhouseChange(event){
        this.housename = event.detail.value;
    }
    handleareaChange(event){
        this.areatown =event.detail.value;
    }
}