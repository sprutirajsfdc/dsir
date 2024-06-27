import { LightningElement, track, api } from 'lwc';
import getInquiries from '@salesforce/apex/InquiryController.getInquiries';
import getStatusPicklistValues from '@salesforce/apex/InquiryController.getStatusPicklistValues';
import getListingTypePicklistValues from '@salesforce/apex/InquiryController.getListingTypePicklistValues';
import getLeadSourcePicklistValues from '@salesforce/apex/InquiryController.getLeadSourcePicklistValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

// const LOADING_THRESHOLD = 300;
export default class InquiryManager extends NavigationMixin(LightningElement) {
    @track status = '';
    @track listingType = '';
    @track unitId = '';
    @track projectId = '';
    @track minPrice;
    @track maxPrice;
    @track bedminPrice;
    @track bedmaxPrice;
    // @track isLoading = false;
    @track leadsource='';
    @track listingUnitNumber = '';
    @api inquiries = [];
    @track pageNumber = 1;
    // @track pageSize = 10;
    @api pageSize = 10;

    @track statusOptions = [];
    @track listingTypeOptions = [];
    @track leadOptions =[];

    @api filterCriteria;

    // Fetch inquiries when the component is initialized
    connectedCallback() {
    this.filterCriteria = {
        unitName: '',
        projectName: '',
        status: '',
        listingType: '',
        listingUnitNumber: '',
        leadsource: ''
    };
    this.fetchStatusPicklistValues();
    this.fetchListingTypePicklistValues();
    this.fetchLeadSourcePicklistValues();
    this.fetchInquiries();
}

    handleReceiveData(event) {
        console.log('inside handleReceiveData of inquiryManager');
       // this.receivedData = event.detail;
        console.log('receivedData : from parent = ',event.detail);
        const filter = event.detail;
        console.log('filter.filterName = '+filter.filterName);
        
        if(filter.filterName == 'status'){
           this.status =  filter.filterValue;
           console.log('status : = '+this.status);
        }
        if(filter.filterName == 'leadsource'){
           this.leadsource =  filter.filterValue;
           console.log('leadsource : = '+this.leadsource);
        }
        // if(filter.filterName == 'status'){
        //    this.status =  filter.filterValue;
        //    console.log('status : = '+this.status);
        // }
        
        if(filter.filterName == 'listingType'){
           this.listingType =  filter.filterValue;
           console.log('listingType : = '+this.listingType);
        }

        if(filter.filterName == 'unitId'){
           console.log('inside if of unitId'); 
           this.unitId =  filter.filterValue;
           console.log('unitId : = '+this.unitId);
        }

        if(filter.filterName == 'projectId'){
           console.log('inside if of projectId'); 
           this.projectId =  filter.filterValue;
           console.log('projectId : = '+this.projectId);
        }
        if(filter.filterName == 'minPrice'){
           console.log('inside if of minPrice'); 
           this.minPrice =  filter.filterValue;
           console.log('minPrice : = '+this.minPrice);
        }
        if(filter.filterName == 'maxPrice'){
           console.log('inside if of maxPrice'); 
           this.maxPrice =  filter.filterValue;
           console.log('maxPrice : = '+this.maxPrice);
        }
        if(filter.filterName == 'bedminPrice'){
           console.log('inside if of bedminPrice'); 
           this.bedminPrice =  filter.filterValue;
           console.log('bedminPrice : = '+this.bedminPrice);
        }
        if(filter.filterName == 'bedmaxPrice'){
           console.log('inside if of bedmaxPrice'); 
           this.bedmaxPrice =  filter.filterValue;
           console.log('maxBedroom : = '+this.bedmaxPrice);
        }

        //call Apex method -  
        this.fetchInquiries();
    }

    //Pagination
    pageSizeOptions = [10, 25, 50, 75, 100]; //Page size options
    //records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records
    //pageSize; 
    pageSize = 10;//No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
     get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    // Fetch inquiries based on filter criteria
    fetchInquiries() {
        //  this.isLoading = true;
        //  const startTime = performance.now();
        console.log('inside fetchInquiries');
    getInquiries({
        unitId: this.unitId,
        projectId: this.projectId,
        status: this.status,
        listingType: this.listingType,
        listingUnitNumber: this.listingUnitNumber,
        leadsource: this.leadsource,
        bedminPrice:this.bedminPrice,
        bedmaxPrice:this.bedmaxPrice,
        minPrice: this.minPrice,
        maxPrice: this.maxPrice
    })
    .then(result => {
        // const endTime = performance.now();
        //     const executionTime = endTime - startTime;
        //     this.isLoading = false;
        //      if (executionTime > LOADING_THRESHOLD) {
        //         this.isLoading = true;
        //     }
        if(result && result.length > 0){
         this.inquiries = result;
         this.records = result;
         this.totalRecords = result.length; // update total records count                 
         this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
         this.paginationHelper(); // call helper menthod to update pagination logic 
        }else{
            this.inquiries = false; 
        }
        
        console.log('this is the result >>>>>'+this.inquiries);
        console.log('this is the result>>>>>'+result);
       

    })
    .catch(error => {
        // this.isLoading = false;
        console.error('Error retrieving inquiries:', error);
        this.inquiries = false;   
    });
}
 handleRecordsPerPage(event) {
        this.pageSize = parseInt(event.target.value, 10);
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // JS function to handel pagination logic 
    paginationHelper() {
    this.recordsToDisplay = [];
    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    const startIndex = (this.pageNumber - 1) * this.pageSize;
    const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
    for (let i = startIndex; i < endIndex; i++) {
        this.recordsToDisplay.push(this.records[i]);
    }
}



    // Fetch status picklist values
    fetchStatusPicklistValues() {
        getStatusPicklistValues()
            .then(result => {
                this.statusOptions = this.generatePicklistOptions(result);
            })
            .catch(error => {
                console.error('Error retrieving Status picklist values:', error);
            });
    }

    // Fetch listing type picklist values
    fetchListingTypePicklistValues() {
        getListingTypePicklistValues()
            .then(result => {
                this.listingTypeOptions = this.generatePicklistOptions(result);
            })
            .catch(error => {
                console.error('Error retrieving Listing Type picklist values:', error);
            });
    }
     get recordPageUrl() {
        if (this.inquiries && this.inquiries.length > 0) {
            return `/${this.inquiries[0].Id}`; 
        }
        return '#'; 
    }
    fetchLeadSourcePicklistValues() {
        getLeadSourcePicklistValues()
            .then(result => {
                this.leadOptions = this.generatePicklistOptions(result);
            })
            .catch(error => {
                console.error('Error retrieving lead Source picklist values:', error);
            });
    }

    // Helper method to generate picklist options
    generatePicklistOptions(data) {
        return data.map(option => ({ label: option, value: option }));
    }

    // Handle input change event
    handleInputChange(event) {
        const { name, value } = event.target;
        this.filterCriteria = { ...this.filterCriteria, [name]: value };
    }

    // Handle search button click
    handleSearch(event) {
    this.filterCriteria = event.detail;
    this.fetchInquiries();
}
}