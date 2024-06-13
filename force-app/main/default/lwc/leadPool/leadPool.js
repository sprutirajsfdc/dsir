import { LightningElement, track, wire,api } from 'lwc';
import getProperties from '@salesforce/apex/LeadController.getProperties';
import getPicklistValues from '@salesforce/apex/LeadController.getPicklistValues';
import { NavigationMixin } from 'lightning/navigation';

export default class LeadPool extends NavigationMixin(LightningElement) {
    @track typeOptions = [];
    @track inquiryOptions = [];
    @track statusOptions = [];
    @track searchKeyword = '';
    @track searchcommunity = '';
    @track searchSubcommunity='';
    @track selectedTypeSearch = '';
    @track selectedStatusSearch = '';
    @track selectedinquiryTypeSearch = '';
    @track bedmax = '';
    @track bedmin = '';
    @track pricemax = '';
    @track pricemin = '';
    @track createdate = '';
    @track lastdate = '';
    @track records = [];
    @track recordsToDisplay = [];
    @track filteredRecords = [];
    @track totalRecords = 0;
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalPages = 0;
     @api recordId;
    
    pageSizeOptions = [
        { value: 5, selected: false },
        { value: 10, selected: true },
        { value: 25, selected: false },
        { value: 50, selected: false },
        { value: 75, selected: false },
        { value: 100, selected: false }
    ];

    get bDisableFirst() {
        return this.pageNumber === 1;
    }

    get bDisableLast() {
        return this.pageNumber === this.totalPages;
    }
    @wire(getProperties)
    wiredProperties({ error, data }) {
        if (data) {
            console.log('Properties data:', data);
            this.handlePropertiesData(data);
        } else if (error) {
            console.error('Properties error:', error);
        }
    }

     handlePropertiesData(data) {
    try {
        // Process the data
        this.records = data.map(record => {
            // Parse date/time values
            const createdDate = this.parseDateTime(record.CreatedDate);
            const lastModifiedDate = this.parseDateTime(record.LastActivityLoggedOn__c);

            return {
                ...record,
                CreatedDateFormatted: createdDate,
                LastModifiedDateFormatted: lastModifiedDate
            };
        });

        this.filteredRecords = this.records;
        this.totalRecords = this.records.length;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
    } catch (error) {
        console.error('Error processing properties data:', error);
    }
}

parseDateTime(dateTimeString) {
    try {
        // Ensure that dateTimeString is not null or empty
        if (!dateTimeString) {
            return ''; // or return null, depending on how you want to handle empty values
        }

        const dateTime = new Date(dateTimeString);
        if (isNaN(dateTime.getTime())) {
            throw new Error('Invalid date/time value: ' + dateTimeString);
        }

        const options = {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        };

        return new Intl.DateTimeFormat('en-GB', options).format(dateTime).replace(',', '');
    } catch (error) {
        console.error('Error parsing date/time:', error);
        return ''; // or return null, depending on how you want to handle errors
    }
}


    @wire(getPicklistValues, { objectApiName: 'pba__Request__c', fieldApiName: 'pba__PropertyType__c' })
    typeOptionsHandler({ error, data }) {
        if (data) {
            this.typeOptions = data;
        } else if (error) {
            console.error('Error fetching type options:', error);
        }
    }

    @wire(getPicklistValues, { objectApiName: 'pba__Request__c', fieldApiName: 'InquiryType__c' })
    inquiryOptionsHandler({ error, data }) {
        if (data) {
            this.inquiryOptions = data;
        } else if (error) {
            console.error('Error fetching inquiry options:', error);
        }
    }

    @wire(getPicklistValues, { objectApiName: 'pba__Request__c', fieldApiName: 'pba__Status__c' })
    statusOptionsHandler({ error, data }) {
        if (data) {
            this.statusOptions = data;
        } else if (error) {
            console.error('Error fetching status options:', error);
        }
    }

    handleSearch(event) {
        this.searchKeyword = event.target.value.toLowerCase();
        this.filterRecords();
    }

    handleSearchcommunity(event) {
        this.searchcommunity = event.target.value.toLowerCase();
        this.filterRecords();
    }
    handleSearchSubcommunity(event){
         this.searchSubcommunity = event.target.value.toLowerCase();
         this.filterRecords();
    }

    handleTYPESearch(event) {
        this.selectedinquiryTypeSearch = event.target.value;
        this.filterRecords();
    }

    handleStatusSearch(event) {
        this.selectedStatusSearch = event.target.value;
        this.filterRecords();
    }

    handleViewSearch(event) {
        this.selectedTypeSearch = event.target.value;
        this.filterRecords();
    }

    handlepriceMinChange(event) {
        this.pricemin = event.target.value;
        this.filterRecords();
    }

    handlepriceMaxChange(event) {
        this.pricemax = event.target.value;
        this.filterRecords();
    }

    handlebedroomMinChange(event) {
        this.bedmin = event.target.value;
        this.filterRecords();
    }

    handlebedroomMaxChange(event) {
        this.bedmax = event.target.value;
        this.filterRecords();
    }

    handleCreatedateChange(event) {
        this.createdate = event.target.value;
        this.filterRecords();
    }

    // handleLastdateChange(event) {
    //     this.lastdate = event.target.value;
    //     this.filterRecords();
    // }

    handleRecordsPerPage(event) {
        this.pageSize = parseInt(event.target.value, 10);
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.pageNumber = 1;
        this.paginationHelper();
    }
     handleCreateStartDateChange(event) {
        this.createStartDate = event.target.value;
        this.filterRecords();
    }

    handleCreateEndDateChange(event) {
        this.createEndDate = event.target.value;
        this.filterRecords();
    }

    // handleLastModifyStartDateChange(event) {
    //     this.lastModifyStartDate = event.target.value;
    //     this.filterRecords();
    // }

    // handleLastModifyEndDateChange(event) {
    //     this.lastModifyEndDate = event.target.value;
    //     this.filterRecords();
    // }

    filterRecords() {
        let filteredRecords = this.records;
        if (this.searchKeyword) {
            filteredRecords = filteredRecords.filter(record => record.Name.toLowerCase().includes(this.searchKeyword));
        }
        if (this.searchcommunity) {
            filteredRecords = filteredRecords.filter(record => record.pba_uaefields__Community_Propertyfinder__c && record.pba_uaefields__Community_Propertyfinder__c.toLowerCase().includes(this.searchcommunity));
        }
         if (this.searchSubcommunity) {
            filteredRecords = filteredRecords.filter(record => record.pba_uaefields__Sub_Community_Propertyfinder__c && record.pba_uaefields__Sub_Community_Propertyfinder__c.toLowerCase().includes(this.searchSubcommunity));
        }
        if (this.selectedTypeSearch) {
            filteredRecords = filteredRecords.filter(record => record.pba__PropertyType__c === this.selectedTypeSearch);
        }
        if (this.selectedStatusSearch) {
            filteredRecords = filteredRecords.filter(record => record.pba__Status__c === this.selectedStatusSearch);
        }
        if (this.selectedinquiryTypeSearch) {
            filteredRecords = filteredRecords.filter(record => record.InquiryType__c === this.selectedinquiryTypeSearch);
        }
        if (this.pricemin) {
            filteredRecords = filteredRecords.filter(record => record.pba__ListingPrice_pb_min__c >= parseFloat(this.pricemin));
        }
        if (this.pricemax) {
            filteredRecords = filteredRecords.filter(record => record.pba__ListingPrice_pb_max__c <= parseFloat(this.pricemax));
        }
        if (this.bedmin) {
            filteredRecords = filteredRecords.filter(record => record.pba__Bedrooms_pb_min__c >= parseFloat(this.bedmin));
        }
        if (this.bedmax) {
            filteredRecords = filteredRecords.filter(record => record.pba__Bedrooms_pb_max__c <= parseFloat(this.bedmax));
        }
         if (this.createStartDate) {
            const createStart = new Date(this.createStartDate);
            filteredRecords = filteredRecords.filter(record => new Date(record.CreatedDate) >= createStart);
        }
        if (this.createEndDate) {
            const createEnd = new Date(this.createEndDate);
            filteredRecords = filteredRecords.filter(record => new Date(record.CreatedDate) <= createEnd);
        }
        // if (this.lastModifyStartDate) {
        //     const lastModifyStart = new Date(this.lastModifyStartDate);
        //     filteredRecords = filteredRecords.filter(record => new Date(record.LastActivityLoggedOn__c) >= lastModifyStart);
        // }
        // if (this.lastModifyEndDate) {
        //     const lastModifyEnd = new Date(this.lastModifyEndDate);
        //     filteredRecords = filteredRecords.filter(record => new Date(record.LastActivityLoggedOn__c) <= lastModifyEnd);
        // }
        this.filteredRecords = filteredRecords;
        this.totalRecords = filteredRecords.length;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.pageNumber = 1;
        this.paginationHelper();
    }

    paginationHelper() {
        const start = (this.pageNumber - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.recordsToDisplay = this.filteredRecords.slice(start, end);
    }

    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }

    previousPage() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.paginationHelper();
        }
    }

    nextPage() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.paginationHelper();
        }
    }

    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }

    handleReset() {
        this.searchKeyword = '';
        this.searchcommunity = '';
        this.searchSubcommunity='';
        this.selectedTypeSearch = '';
        this.selectedStatusSearch = '';
        this.selectedinquiryTypeSearch = '';
        this.bedmax = '';
        this.bedmin = '';
        this.pricemax = '';
        this.pricemin = '';
        this.createdate = '';
        this.lastdate = '';
        this.filteredRecords = this.records;
        this.totalRecords = this.records.length;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.pageNumber = 1;
        this.paginationHelper();
    }

    navigateToProject(event) {
        const projectId = event.currentTarget.dataset.id;
    if (projectId) {
        console.log('projectId:', projectId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: projectId,
                objectApiName: 'pba__Request__c',
                actionName: 'view'
            }
        });
    } else {
        console.error('ProjectId is undefined or null. Cannot navigate.');
    }
    }

    navigateToProject(event) {
    const projectId = event.currentTarget.dataset.id;
    if (projectId) {
        console.log('projectId:', projectId);
        // Construct the URL for the record page
        const url = `/lightning/r/pba__Request__c/${projectId}/view`;

        // Open the URL in a new tab
        window.open(url, '_blank');
    } else {
        console.error('ProjectId is undefined or null. Cannot navigate.');
    }
}

    formatDate(dateString) {
        const date = new Date(dateString);
        const options = {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        };
        return new Intl.DateTimeFormat('en-GB', options).format(date).replace(',', '');
    }
    handleToday() {
    const today = new Date().toISOString().slice(0, 10);
    this.createdate = today;
    this.lastdate = today;
     this.filterRecords();
}

handleLast7Days() {
    const today = new Date();
    const lastWeek = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 7).toISOString().slice(0, 10);
    const todayISO = today.toISOString().slice(0, 10);
    this.createdate = lastWeek;
    this.lastdate = todayISO;
     this.filterRecords();
}

handleLast30Days() {
    const today = new Date();
    const lastMonth = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 30).toISOString().slice(0, 10);
    const todayISO = today.toISOString().slice(0, 10);
    this.createdate = lastMonth;
    this.lastdate = todayISO;
     this.filterRecords();
}

handleThisWeek() {
    const today = new Date();
    const firstDayOfWeek = new Date(today.setDate(today.getDate() - today.getDay())).toISOString().slice(0, 10);
    const todayISO = today.toISOString().slice(0, 10);
    this.createdate = firstDayOfWeek;
    this.lastdate = todayISO;
     this.filterRecords();
}

handleThisMonth() {
    const today = new Date();
    const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1).toISOString().slice(0, 10);
    const todayISO = today.toISOString().slice(0, 10);
    this.createdate = firstDayOfMonth;
    this.lastdate = todayISO;
     this.filterRecords();
}
handleThisYear(){
     const today = new Date();
        const firstDayOfYear = new Date(today.getFullYear(), 0, 1).toISOString().slice(0, 10);
        const todayISO = today.toISOString().slice(0, 10);
        this.createdate = firstDayOfYear;
        this.lastdate = todayISO;
        this.filterRecords();
}

}