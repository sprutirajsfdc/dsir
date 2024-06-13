import { LightningElement, wire, api, track } from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';
import getUnitDetails from '@salesforce/apex/UnitDetailsController.getUnitDetails';
import { NavigationMixin } from 'lightning/navigation';
import getProjects from '@salesforce/apex/PropertyController.getProjects';

export default class ProjectPayment extends NavigationMixin(LightningElement) {
    @track selectedProjectName;
    @track options = [];
    @track unitDetails = [];
    @track fetchedData = []; // Track fetched data separately
    @track typeOptions = [];
    @api recordId;
    @track searchKeyword;
    @track prevSearchKeyword = false;
    @track prevSelectedProjectName = false;
   
    @track selectedBedSearch;
    @track prevSelectedBedSearch = false;
    @track isModalOpen = false;


    @wire(getProperties, {})
    wiredProperties({ error, data }) {
        if (data) {
            this.options = data.map(property => ({
                label: `${property.os_Project_Name__c} - ${property.os_Unit_Number__c}`,
                value: property.Id
            }));
            console.log('Properties Data:', JSON.stringify(this.options));
        } else if (error) {
            console.error('Error fetching properties:', error);
        }
    }

    @wire(getProjects)
    projects({ error, data }) {
        if (data) {
            this.options = data.map(project => ({ label: project.Name, value: project.Id }));
        } else if (error) {
            console.error('Error fetching projects:', error);
        }
    }

    handleValueChange(event) {
        if (this.selectedProjectName) {
            this.prevSelectedProjectName = true;
        }
        this.selectedProjectName = event.detail.value;
        this.filterProjectDataHandler();
    }

    @wire(getUnitDetails)
    wiredUnitDetails({ error, data }) {
        if (data) {
            this.fetchedData = JSON.parse(JSON.stringify(data));
            this.unitDetails = this.fetchedData;
            this.recordsToDisplay = this.fetchedData;
            this.paginationHelper();
        } else if (error) {
            console.error('Error fetching unit details:', error);
        }
    }

    handleSearch(event) {
        if (this.searchKeyword) {
            this.prevSearchKeyword = true;
        }
        this.searchKeyword = event.target.value;
        this.filterSearchDataHandler();
    }

    filterProjectDataHandler() {
        let filterData = [];
        if (this.prevSelectedProjectName) {
            this.unitDetails = this.fetchedData;
            this.prevSelectedProjectName = false;
            this.filterProjectDataHandler();
            //this.paginationHelper();
        } else if (this.selectedProjectName) {
            const selectedProject = this.options.find(option => option.value === this.selectedProjectName);
            if (selectedProject) {
                filterData = this.fetchedData.filter(unit => unit.os_Project_Name__c === selectedProject.label);
                this.unitDetails = filterData;
                this.recordsToDisplay = filterData;
            }
        }
      this.paginationHelper();
    }

    filterSearchDataHandler() {
        let filterData = [];
        if (this.prevSearchKeyword) {
            this.unitDetails = this.fetchedData;
            this.prevSearchKeyword = false;
            this.filterSearchDataHandler();
            //this.paginationHelper();
        } else if (this.searchKeyword) {
            filterData = this.fetchedData.filter(unit => unit.os_Unit_Number__c.includes(this.searchKeyword));
            this.unitDetails = filterData;
            this.recordsToDisplay = filterData;
            
        }
        this.paginationHelper();
    }

    handleClick(event) {
        const unitId = event.target.dataset.id;
        // Implement your logic for handling the Add Payment Plan button click
        console.log('Add Payment Plan for unit:', unitId);
    }

    navigateToRecordPage(event) {
        const recordId = event.target.dataset.id;
        // Implement your navigation logic to the record page
        console.log('Navigate to record page:', recordId);
    }

    handlebedSearch(event) {
        if (this.selectedBedSearch) {
            this.prevSelectedBedSearch = true;
        }
        this.selectedBedSearch = event.detail.value;
        console.log('bed', JSON.stringify(this.selectedBedSearch));
        this.filterBedDataHandler();
    }

    filterBedDataHandler() {
        let filterData = [];
        if (this.prevSelectedBedSearch) {
            this.unitDetails = this.fetchedData;
            this.prevSelectedBedSearch = false;
            this.filterBedDataHandler();
        } else if (this.selectedBedSearch) {
            filterData = this.fetchedData.filter(unit => unit.bed === this.selectedBedSearch);
            this.unitDetails = filterData;
            this.recordsToDisplay = filterData;
            
        }
        this.paginationHelper();
    }
     
    handleClick() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    navigateToRecordPage(){
        const projectId = event.currentTarget.dataset.id;
        
        console.log('projectId:', projectId); 
       this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: projectId,
             objectApiName: 'OS_Property__c',
            actionName: 'view'
        }
        });
    }
     handleReset() {
        this.selectedProjectName = '';
        this.searchKeyword = '';
        this.recordsToDisplay = [];
        // Optionally, you can reset other filters or state variables as needed
    }
     pageSizeOptions = [
                {
                    value:5,
                    selected:false
                },
                {
                    value:10,
                    selected:true
                },
                {
                    value:25,
                    selected:false
                },
                {
                    value:50,
                    selected:false
                },
                {
                    value:75,
                    selected:false
                },
                {
                    value:100,
                    selected:false
                }]; //Page size options
    records = []; // All records available in the data table
    columns = []; // Columns information available in the data table
    totalRecords = 0; // Total number of records
    pageSize; // Number of records to be displayed per page
    totalPages; // Total number of pages
    pageNumber = 1; // Page number
    recordsToDisplay = [];
     get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
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
    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalRecords=this.unitDetails.length;

        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.unitDetails[i]);
        }
    }
}