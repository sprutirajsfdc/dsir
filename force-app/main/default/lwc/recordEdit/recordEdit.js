import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';;
export default class RecordEdit extends LightningElement {
    @api recordId;

    handleSubmit(event){
        const evt = new ShowToastEvent({
            title: 'Success Message',
            message: 'Record Created successfully ',
            variant: 'success',
            mode:'dismissible'
        });
        this.dispatchEvent(evt);

    }
}