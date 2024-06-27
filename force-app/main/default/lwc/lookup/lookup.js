import { LightningElement ,api,wire} from 'lwc';
import fetchRecords from '@salesforce/apex/SearchController.fetchRecords';
/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 500;export default class Lookup extends LightningElement {
@api helpText = "Search Unit Name";
    @api label = "Parent Inquiry";
    @api required;
    @api selectedIconName = "standard:account";
    @api objectLabel = "Unit";
    recordsList = [];
    selectedRecordName;

    @api objectApiName = "CD_Property__c";
    @api fieldApiName = "Name";
    @api otherFieldApiName = "Status__c";
    @api searchString = "";
    @api selectedRecordId = "";
    @api parentRecordId;
    @api parentFieldApiName;

    preventClosingOfSerachPanel = false;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            otherFieldApiName: this.otherFieldApiName,
            searchString: this.searchString,
            selectedRecordId: this.selectedRecordId,
            parentRecordId: this.parentRecordId,
            parentFieldApiName: this.parentFieldApiName
        };
    }

    get showRecentRecords() {
        if (!this.recordsList) {
            return false;
        }
        return this.recordsList.length > 0;
    }

    //getting the default selected record
    connectedCallback() {
        if (this.selectedRecordId) {
            this.fetchSobjectRecords(true);
        }
    }

    //call the apex method
    fetchSobjectRecords(loadEvent) {
        fetchRecords({
            inputWrapper: this.methodInput
        }).then(result => {
            if (loadEvent && result) {
                this.selectedRecordName = result[0].mainField;
            } else if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
            } else {
                this.recordsList = [];
            }
        }).catch(error => {
            console.log(error);
        })
    }

    get isValueSelected() {
        return this.selectedRecordId;
    }

    //handler for calling apex when user change the value in lookup
    handleChange(event) {
     //   console.log('in handleChange!');
        this.searchString = event.target.value;
        this.fetchSobjectRecords(false);
    }

    //handler for clicking outside the selection panel
    handleBlur(event) {
        console.log('in handleBlur!');
        this.recordsList = [];
        this.preventClosingOfSerachPanel = false;

        //pass selected value to 
    }

    //handle the click inside the search panel to prevent it getting closed
    handleDivClick() {
        this.preventClosingOfSerachPanel = true;
    }

    //handler for deselection of the selected item
    handleCommit() {
        this.selectedRecordId = "";
        this.selectedRecordName = "";
    }

    //handler for selection of records from lookup result list
    handleSelect(event) {
        console.log('inside handleSelect!');
        let selectedRecord = {
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield,
            id: event.currentTarget.dataset.id
        };
        this.selectedRecordId = selectedRecord.id;
        this.selectedRecordName = selectedRecord.mainField;
        console.log('this.selectedRecordName = '+this.selectedRecordName);
        console.log('this.selectedRecordId = '+this.selectedRecordId);
        this.recordsList = [];
        
        const filter = this.setFilterObject('unitId', this.selectedRecordId);
        console.log('filter = ',filter);
        const childEvent = new CustomEvent('senddata', { detail: filter });
        this.dispatchEvent(childEvent);
        console.log('dispatched from handleStatusChange');
        /*
        // Creates the event
        const selectedEvent = new CustomEvent('valueselected', {
            detail: selectedRecord
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
        */
    }

    setFilterObject(filterName, filterValue){
        const filter = {
            filterName: filterName,
            filterValue: filterValue
        };
        return filter;
    }
    
    //to close the search panel when clicked outside of search input
    handleInputBlur(event) {
        // Debouncing this method: Do not actually invoke the Apex call as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
        }, DELAY);
    }
}