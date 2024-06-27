import { LightningElement, wire, api, track } from 'lwc';
import getAllPortals from '@salesforce/apex/PortalListingsLWC_Controller.getAllPortals';
import publish_Or_Unpublish from '@salesforce/apex/PortalListingsLWC_Controller.publish_Or_Unpublish';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PortalListingsLWC extends LightningElement {
    @api recordId;
    @track isLoading = false;
    // WORKS: -
    columns = [
        { label: 'Portal Name', fieldName: 'portalName', type: 'text' },
        //   { label: 'Portal Status', fieldName: 'PortalStatus', type: 'text' },
        {
            label: 'Portal Status',
            fieldName: 'PortalStatus',
            type: 'text',
            cellAttributes: {
                class: {
                    fieldName: 'statusColor'
                }
            }
        },
        /*   {
               label: 'Publish Status',
               fieldName: 'publishStatus',
               type: 'button',
               initialWidth: 100,
               cellAttributes: {
                   class: { 
                           fieldName: 'buttonColor' 
                           }
                 //          ,                iconName: { fieldName: 'iconName' }, iconPosition: 'right'
               }
           }   */
        {
            type: "button", typeAttributes: {
                label: {
                    fieldName: 'publishStatus'
                },
                class: {
                    fieldName: 'buttonColor'
                },
                disabled: {
                    fieldName: 'buttonActive'
                },

                variant: {
                    fieldName: 'buttonColor'
                },
                onclick: (event) => this.handleButtonClick(event, event.target.dataset.portalname) // Pass portalName value as parameter
            }
        }
    ];

    @track portalsList;


    @wire(getAllPortals, { recordId: "$recordId" })
    portalsListRec({ data, error }) {
        console.log('recordId = ' + this.recordId);    
    
        if (data) {
            let dataCopy = JSON.parse(JSON.stringify(data));

            dataCopy.forEach(currentItem => {
                currentItem.statusColor = currentItem.PortalStatus == 'Inactive' ? "slds-text-color_error" : "slds-text-color_success";
                //     currentItem.PortalStatus = currentItem.PortalStatus == 'Inactive' ? 'test1' : 'test2'; //works
                console.log('currentItem.isPublishedOnPortal = ' + currentItem.isPublishedOnPortal);
                currentItem.publishStatus = currentItem.isPublishedOnPortal ? 'Unpublish' : 'Publish';
             //   currentItem.buttonActive = false; //comment
                currentItem.buttonActive = currentItem.PortalStatus == 'Inactive' ? true : false;   //uncomment
                currentItem.buttonColor = currentItem.isPublishedOnPortal ? "destructive" : "success";

                

            });

            this.portalsList = dataCopy;
            console.log('this.portalsList = ' + this.portalsList);

        } else if (error) {
            
            this.data = undefined;
            this.error = error;
            console.log('The error is - '+error);
        }


    }



    handleRowAction(event) {
        //loader
                this.isLoading = true;
                console.log('spinner : on');
                // contains properties of the clicked row
        console.log('in handleRowAction, btn clicked!');
        const row = event.detail.row;

        //1. fetch Portal Name, publishStatus
        console.log('row name = ' + row.portalName);
        let portalName = row.portalName;
        let publishStatus = row.publishStatus;
        console.log('row publishStatus: ', row.publishStatus);

        //2. send it to Apex method

        publish_Or_Unpublish({
            websiteName: portalName,
            actionName: publishStatus,
            listingRecordId: this.recordId
        })
            .then(result => {

                console.log('result = ' + result);

            this.isLoading = false;
            console.log('spinner : off');
                
                const event = new ShowToastEvent({
                    title: 'Listing '+publishStatus + 'ed',
                    message: 'Listing '+publishStatus + 'ed successfully!',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                window.location.reload();
                
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Something went wrong while publishing the listing on Portal',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });

    }

    handleButtonClick(event, portalName) {
        // Access the portalName value here
        console.log('Button clicked for portal: ', portalName);

    }

}