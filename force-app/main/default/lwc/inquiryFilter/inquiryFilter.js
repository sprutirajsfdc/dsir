import { LightningElement, track, wire } from 'lwc';
import getStatusPicklistValues from '@salesforce/apex/InquiryController.getStatusPicklistValues';
import getListingTypePicklistValues from '@salesforce/apex/InquiryController.getListingTypePicklistValues';
import getLeadSourcePicklistValues from '@salesforce/apex/InquiryController.getLeadSourcePicklistValues';
export default class InquiryFilter extends LightningElement {
    @track unitName = '';
    @track projectName = '';
    @track status = '';
    @track leadsource='';
    @track listingType = '';
    @track listingUnitNumber = '';

    @track statusOptions = [];
    @track leadOptions=[];
    @track listingTypeOptions = [];

    connectedCallback() {
        this.fetchStatusPicklistValues();
        this.fetchListingTypePicklistValues();
        this.fetchLeadSourcePicklistValues();
    }

    fetchStatusPicklistValues() {
        getStatusPicklistValues()
            .then(result => {
                this.statusOptions = result.map(option => ({ label: option, value: option }));
            })
            .catch(error => {
                console.error('Error retrieving Status picklist values:', error);
            });
    }

    fetchListingTypePicklistValues() {
        getListingTypePicklistValues()
            .then(result => {
                this.listingTypeOptions = result.map(option => ({ label: option, value: option }));
            })
            .catch(error => {
                console.error('Error retrieving Listing Type picklist values:', error);
            });
    }
    fetchLeadSourcePicklistValues() {
        getLeadSourcePicklistValues()
            .then(result => {
                this.leadOptions = result.map(option => ({ label: option, value: option }));
            })
            .catch(error => {
                console.error('Error retrieving LeadSource picklist values:', error);
            });
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this[name] = value;
    }

    handleStatusChange(event) {
        console.log('event.target from handleStatusChange = ' + event.detail.value);
        const filter = this.setFilterObject('status', event.detail.value);

        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleStatusChange');
    }
    handleleadChange(event){
         console.log('event.target from handleleadChange = ' + event.detail.value);
        const filter = this.setFilterObject('leadsource', event.detail.value);

        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleleadChange');
    }

    handleListingTypeChange(event) {
        console.log('event.target from handleListingTypeChange = ' + event.detail.value);
        const filter = this.setFilterObject('listingType', event.detail.value);
        //   const listingType = event.detail.value;
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleListingTypeChange');
    }


    handleDropdownChange(event) {
        console.log('event.target from handleDropdownChange = ' + event.detail.value);
        const eventData = event.detail.value;
        //  const eventData = 'Hello from Child';
        const childEvent = new CustomEvent('senddata', { detail: eventData });
        this.dispatchEvent(childEvent);
        console.log('dispatched');

        //       const { name, value } = event.detail.value;
        //    this[name] = value;

    }

    handleUnitNameSelected(event) {
    }

    handleSearch() {
        const searchCriteria = {
            unitName: this.unitName,
            projectName: this.projectName,
            status: this.status,
            listingType: this.listingType,
            leadsource: this.leadsource,
            listingUnitNumber: this.listingUnitNumber
        };
        this.dispatchEvent(new CustomEvent('search', { detail: searchCriteria }));
    }
    handleClear() {
         this.status = null;
        this.leadsource = null;
        this.listingType = null;
        this.minPrice = null;
        this.maxPrice = null;
        this.bedminPrice = null;
        this.bedmaxPrice = null;

        const searchCriteria = {
            status: this.status,
            leadsource: this.leadsource,
            listingType: this.listingType,
            minPrice: this.minPrice,
            maxPrice: this.maxPrice,
            bedminPrice: this.bedminPrice,
            bedmaxPrice: this.bedmaxPrice
        };
        this.dispatchEvent(new CustomEvent('search', { detail: searchCriteria }));
    }

    setFilterObject(filterName, filterValue) {
        const filter = {
            filterName: filterName,
            filterValue: filterValue
        };
        return filter;
    }

    handleReceiveDataUnitName(event) {
        // this.receivedData = event.detail;
        console.log('handleReceiveDataUnitName : from inquiryFilter = ', event.detail);
        const filter = event.detail;
        console.log('filterName = ', filter.filterName);
        console.log('filterValue = ', filter.filterValue);

        //send data to inquiryManager
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleReceiveDataUnitName');

    }

    handleReceiveDataProjectName(event) {
        // this.receivedData = event.detail;
        console.log('handleReceiveDataProjectName : from inquiryFilter = ', event.detail);
        const filter = event.detail;
        console.log('filterName = ', filter.filterName);
        console.log('filterValue = ', filter.filterValue);

        //send data to inquiryManager
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleReceiveDataProjectName');

    }
    handlebedroomMinpriceMinChange(event){
        console.log('inside handlebedroomMinpriceMinChange');
        console.log('inside handlebedroomMinpriceMinChange = ', event.detail.value);
        const filter = this.setFilterObject('bedminPrice', event.detail.value);
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handlebedroomMinpriceMinChange');
    }
    handlebedMaxpriceMaxChange(event){
        console.log('inside handlebedMaxpriceMaxChange');
        console.log('inside handlebedMaxpriceMaxChange = ', event.detail.value);
        const filter = this.setFilterObject('bedmaxPrice', event.detail.value);
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
    }

    handlepriceMinChange(event) {
        console.log('inside handlepriceminChange');
        console.log('inside handlepriceminChange = ', event.detail.value);
        const filter = this.setFilterObject('minPrice', event.detail.value);
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handlepriceminChange');

    }

    handlepriceMaxChange(event) {
        console.log('inside handlepriceMaxChange');
        console.log('inside handlepriceMaxChange = ', event.detail.value);
        //pass the value to parent lwc
        const filter = this.setFilterObject('maxPrice', event.detail.value);
        //   const listingType = event.detail.value;
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handlepriceMaxChange');

    }
}