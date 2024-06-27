import { LightningElement, track, wire } from 'lwc';
import getdata from '@salesforce/apex/UserDataController.getdata';
import getPicklistValues from '@salesforce/apex/UserDataController.getPicklistValues';
import { NavigationMixin } from 'lightning/navigation';

export default class PasswordManager extends NavigationMixin(LightningElement) {
    @track dataPrivacyRecords = [];
    @track displayedRecords = [];
    @track isModalOpen = false;
    @track viewOptions;
    @track units = [];
    @track prevSelectedViewSearch = false;
    @track unitDetails = []; // Initialize unitDetails as an empty array
    @track selectedViewSearch; // Initialize selectedViewSearch to track the current selection

    searchTerm = '';

    connectedCallback() {
        this.fetchRecords();
    }

    fetchRecords() {
        getdata({ searchTerm: this.searchTerm }) // Pass searchTerm parameter
            .then(result => {
                this.dataPrivacyRecords = result;
                this.displayedRecords = result; // Initially display all records
                this.unitDetails = result; // Initialize unitDetails with fetched data
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    openAppUrl(event) {
        event.preventDefault();
        const url = event.currentTarget.dataset.url;
        window.open(url, '_blank');
    }

    handleClick() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    navigateToRecordViewPage(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                actionName: 'view'
            }
        });
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.fetchRecords();
    }

    @wire(getPicklistValues, { objectApiName: 'Data__c', fieldApiName: 'Credtional_Option__c' })
    typeOptionsHandler({ error, data }) {
        if (data) {
            this.viewOptions = data;
            console.log('Status data>>>', data);
        } else if (error) {
            console.error('Error fetching type options:', error);
        }
    }

    handleViewSearch(event) {
        if (this.selectedViewSearch) {
            this.prevSelectedViewSearch = true;
        }
        this.selectedViewSearch = event.detail.value;
        this.filterViewDataHandler();
    }

    filterViewDataHandler() {
        let filterData = [];
        let tempData = [];

        if (this.prevSelectedViewSearch) {
            this.unitDetails = this.dataPrivacyRecords; // Use dataPrivacyRecords as fetchedData
            this.prevSelectedViewSearch = false;
            this.filterViewDataHandler();
        } else if (this.unitDetails.length !== 0 && this.selectedViewSearch) {
            if (this.dataPrivacyRecords === this.unitDetails) {
                tempData = this.dataPrivacyRecords;
            } else {
                tempData = this.unitDetails;
            }
            for (let i = 0; i < tempData.length; i++) {
                if (tempData[i].Credtional_Option__c === this.selectedViewSearch) {
                    filterData.push(tempData[i]);
                }
            }
            this.unitDetails = filterData;
        }

        this.displayedRecords = this.unitDetails; // Ensure displayedRecords is updated
    }
}