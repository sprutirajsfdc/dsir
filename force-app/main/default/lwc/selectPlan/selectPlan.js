import { LightningElement ,wire,track} from 'lwc';
import getPaymentPlans from '@salesforce/apex/PropertyController.getPaymentPlans';

export default class SelectPlan extends LightningElement {
  
    @track selectedPlanId;
    @track plans = [];
    @track childComponentName;
    


    @wire(getPaymentPlans)
    wiredPaymentPlans({ error, data }) {
        if (data) {
            this.plans = data.map(plan => ({
                label: plan.Name,
                value: plan.Id
            }));
           
        } else if (error) {
            console.error('Error fetching payment plans:', error);
        }
    }
    planComponentMap = {
        'a1IDz000007IU0sMAG': 'c-plan-One',
        'a1IDz000007IU0xMAG': 'c-plan-Two'
    };

    handlePlanChange(event) {
        this.selectedPlanId = event.detail.value;
        this.updateChildComponents();
    }

    updateChildComponents() {
        if (this.selectedPlanId && this.planComponentMap[this.selectedPlanId]) {
            this.childComponentName = this.planComponentMap[this.selectedPlanId];
        } else {
            console.error('Selected plan ID not found in planComponentMap:', this.selectedPlanId);
        }
    }
    get isPlanOne() {
        return this.selectedPlanId === 'a1IDz000007IU0sMAG';
    }

    get isPlanTwo() {
        return this.selectedPlanId === 'a1IDz000007IU0xMAG';
    }

}