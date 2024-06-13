import { LightningElement,wire } from 'lwc';
import getPaymentsByOrder from '@salesforce/apex/PaymentController.getPaymentsByOrder';
const columns = [
    { label: 'Description', fieldName: 'Name', type: 'text' },
    { label: 'Percentage', fieldName: 'Percentage__c', type: 'email' },
    { label: 'Installment Amount', fieldName: 'Install__c', type: 'email' },
    { label: 'Mode of Payment	', fieldName: 'Mode_of_Payment__c', type: 'email' },
    { label: 'Paid Amount', fieldName: 'Paid_Amount__c', type: 'email' },
    { label: 'Paid Date	', fieldName: 'Paid_Date__c', type: 'email' },
    { label: 'Outstand Amount', fieldName: 'Outstand_Amount__c', type: 'email' }

    
];
export default class Print extends LightningElement {
    columns = columns;
    data;

    @wire(getPaymentsByOrder)
    wiredData({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.error('Error fetching data: ', error);
        }
    }
    generatePDF() {
        const pdf = new jsPDF();
        const content = this.template.querySelector('lightning-card').innerHTML;
        pdf.text(content, 10, 10);
        pdf.save('data-table.pdf');
    }
    
}