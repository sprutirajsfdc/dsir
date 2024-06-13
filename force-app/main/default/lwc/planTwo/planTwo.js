import { LightningElement,track,wire} from 'lwc';
import getPlanOrder2 from '@salesforce/apex/PaymentController.getPlanOrder2';
import getPicklistValues from '@salesforce/apex/PicklistValuesController.getPicklistValues';
import updatePayments from '@salesforce/apex/PaymentController.updatePayments';
import jsPDFResource from '@salesforce/resourceUrl/jsPDF';
import { loadScript } from 'lightning/platformResourceLoader';

export default class PlanTwo extends LightningElement {


    @track payments = [];
    @track error;
    jsPDFInitialized = false;
    attachment;
    paymentOptions = []; 
    @track paymentOptions;

    @wire(getPlanOrder2)
wiredPayments({ error, data }) {
    if (data) {
        this.payments = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.payments = [];
    }
}

calculateTotals() {
    this.outstandingAmountTotal = this.payments.reduce((total, payment) => {
        return total + (payment.Outstanding_Amount__c >= 0 ? payment.Outstanding_Amount__c : -payment.Outstanding_Amount__c);
    }, 0);
    this.balanceSalesPriceTotal = this.payments.reduce((total, payment) => {
        return total + (payment.Balance_Sale_Price__c >= 0 ? payment.Balance_Sale_Price__c : -payment.Balance_Sale_Price__c);
    }, 0);
}
@wire(getPicklistValues, { objectApiName: 'Payment_Line__c', fieldApiName: 'Mode_of_Payment__c'})
  Handler({ error, data }) {
        if (data) {
            this. paymentOptions = data;
            console.log('Status dtaa>>>'+data);
        } else if (error) {
            console.error('Error fetching type options:', error);
        }
    }
saveChanges() {
        const updatedRecords = this.payments.map(payment => {
            return {
                Id: payment.Id,
                Paid_Amount__c: payment.Paid_Amount__c,
                Paid_date__c: payment.Paid_date__c
            };
        });

        updatePayments({ payments: updatedRecords })
            .then(result => {
                console.log('Records updated successfully');
            })
            .catch(error => {
                console.error('Error updating records:', error);
            });
    }
    
    handlePaidAmountChange(event) {
    const paymentId = event.target.dataset.id;
    const updatedAmount = event.target.value;
    // Find the payment record by Id
    const paymentToUpdate = this.payments.find(payment => payment.Id === paymentId);
    if (paymentToUpdate) {
        // Create a new array with updated payment records
        const updatedPayments = this.payments.map(payment => {
            if (payment.Id === paymentId) {
                // Create a copy of the payment object and update the Paid Amount
                return { ...payment, Paid_Amount__c: updatedAmount };
            }
            return payment;
        });
        // Assign the updated array back to the payments property
        this.payments = updatedPayments;
    }
}

handlePaidDateChange(event) {
    const paymentId = event.target.dataset.id;
    const updatedDate = event.target.value;
    // Find the payment record by Id
    const paymentToUpdate = this.payments.find(payment => payment.Id === paymentId);
    if (paymentToUpdate) {
        // Create a new array with updated payment records
        const updatedPayments = this.payments.map(payment => {
            if (payment.Id === paymentId) {
                // Create a copy of the payment object and update the Paid Date
                return { ...payment, Paid_date__c: updatedDate };
            }
            return payment;
        });
        // Assign the updated array back to the payments property
        this.payments = updatedPayments;
    }
}
PrintClick(){
    const unitId = this.selectedUnitId;
    if (unitId) {
        window.open('/apex/Payprint?unitId=' + unitId, '_blank');
    } else {
      
        alert('Please select a unit first.');
    }
}


}
