import { LightningElement } from 'lwc';
export default class ContactDashboard extends LightningElement {
powerBIReportUrl2="https://app.powerbi.com/reportEmbed?reportId=76fe8ba6-15d6-4da3-9179-3de6afe8f6fb&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    handleClick() {
        //this.showPowerBIReport = !this.showPowerBIReport; 
        window.open(this.powerBIReportUrl, '_blank', 'width=1200,height=800');
    }

    handleClickS(){
      // this.showPowerBIReport2=!this.showPowerBIReport2;
      window.open(this.powerBIReportUrl2, '_blank', 'width=1200,height=800');
    }
}