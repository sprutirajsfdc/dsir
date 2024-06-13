import { LightningElement ,api,track,wire} from 'lwc';
import getplanOrder from '@salesforce/apex/PaymentController.getplanOrder';
import updatePayments from '@salesforce/apex/PaymentController.updatePayments';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUnitDetails from '@salesforce/apex/PaymentController.getUnitDetails';
import getPicklistValues from '@salesforce/apex/PicklistValuesController.getPicklistValues';
import { createRecord } from 'lightning/uiRecordApi';
import PAYMENT_PLAN_OBJECT from '@salesforce/schema/Payment_Line__c';
export default class PlanOne extends LightningElement {
    @track payments = [];
    @track error;
    @track units = [];
    selectedUnitId = '';
    @track paymentOptions = [];

    @wire(getplanOrder)
wiredPayments({ error, data }) {
    if (data) {
        this.payments = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.payments = [];
    }
}
@wire(getUnitDetails)
wiredUnits({ error, data }) {
    if (data) {
        this.units = data.map(unit => ({ label: unit.Name, value: unit.Id }));
    } else if (error) {
        this.error = error;
        console.error('Error fetching unit details', error);
    }
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
    handleSave(event) {
    const paymentId = event.target.dataset.id;
        const payment = this.payments.find(payment => payment.Id === paymentId);
        if (payment) {
            const fields = {
                'Percentage__c': payment.Percentage__c,
                'Mode_of_Payment__c': payment.Mode_of_Payment__c,
                'Paid_Amount__c': payment.Paid_Amount__c,
                'Paid_date__c': payment.Paid_date__c,
                'Unit__c': this.selectedUnitId, 
                'Name': payment.Name
            };

            const recordInput = { apiName: PAYMENT_PLAN_OBJECT.objectApiName, fields };

            createRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Payment Plan record created',
                            variant: 'success',
                        }),
                    );
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating payment plan',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
        }
}

showToast(title, message, variant) {
    console.log('Showing Toast:', title, message, variant); // Debug log statement
    const toastEvent = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(toastEvent);
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

handleUnitChange(event) {
    this.selectedUnitId = event.detail.value;
    const selectedUnit = this.units.find(unit => unit.value === this.selectedUnitId);
    if (selectedUnit) {
        const updatedPayments = this.payments.map(payment => ({
            ...payment,
            Installment_Amount__c: selectedUnit.Installment_Amount__c
        }));
        this.payments = [...updatedPayments];
        this.calculateTotals();
    }
}
handleUnitChange(event){
    this.selectedUnitId = event.detail.value;
    console.log('Selected Unit ID:', this.selectedUnitId);
}
handlepercentaegChange(event){
    const paymentId = event.target.dataset.id;
    const value = event.target.value;
    this.updatePaymentField(paymentId, 'Percentage__c', value);
}
handleModeOfPayment(event) {
    const paymentId = event.target.dataset.id;
    const value = event.target.value;
    this.updatePaymentField(paymentId, 'Mode_of_Payment__c', value);
}
printclick(){
    const unitId = this.selectedUnitId;
    if (unitId) {
        window.open('/apex/Payprint?unitId=' + unitId, '_blank');
    } else {
      
        alert('Please select a unit first.');
    }
}
}