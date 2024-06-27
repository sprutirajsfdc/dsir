import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Verificationupdate extends LightningElement {
 @api recordId;

    handleSuccess(event) {
       const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Contact Validation updated successfully',
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
        console.log('in handleSuccess!');
    }
    
}