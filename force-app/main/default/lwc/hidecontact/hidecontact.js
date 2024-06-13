import { LightningElement,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import hideContact from '@salesforce/apex/ContactVisibilityController.hideContact';
export default class Hidecontact extends LightningElement {
    @api recordId;

    handleClick() {
        hideContact({ contactId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact hidden successfully',
                        variant: 'success'
                    })
                );
                // Refresh the view to reflect the changes
                this.refreshView();
            })
            .catch(error => {
                let errorMessage = 'Unknown error';
                if (error.body) {
                    if (error.body.message) {
                        errorMessage = error.body.message;
                    } else {
                        errorMessage = JSON.stringify(error.body);
                    }
                } else {
                    errorMessage = error.message || errorMessage;
                }

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error hiding contact',
                        message: errorMessage,
                        variant: 'error'
                    })
                );
            });
    }
    refreshView() {
        // Optionally, refresh the page or component to reflect the changes
        const refreshEvent = new CustomEvent('refresh', {
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(refreshEvent);
    }
}