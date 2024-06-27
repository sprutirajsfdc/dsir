import { LightningElement } from 'lwc';
export default class KSA extends LightningElement {
powerBIReportUrl2="https://app.powerbi.com/reportEmbed?reportId=ea25546a-c077-4413-96e2-0c8274c6b895&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    handleClick() {
        //this.showPowerBIReport = !this.showPowerBIReport; 
        window.open(this.powerBIReportUrl, '_blank', 'width=1200,height=800');
    }

    handleClickS(){
      // this.showPowerBIReport2=!this.showPowerBIReport2;
      window.open(this.powerBIReportUrl2, '_blank', 'width=1200,height=800');
    }
}