import { LightningElement,track} from 'lwc';
export default class Poerbi extends LightningElement {
  // @track showPowerBIReport = false;
  // @track showPowerBIReport2= false;
   powerBIReportUrl1 = "https://app.powerbi.com/reportEmbed?reportId=67981533-1195-4bf8-827f-00bc6f0f51f1&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    
    powerBIReportUrl2="https://app.powerbi.com/reportEmbed?reportId=08a8739b-0e29-44d7-a07c-47abb66a8991&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    powerBIReportUrl3="https://app.powerbi.com/reportEmbed?reportId=5e492e35-705a-433c-8585-326f1160351b&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    powerBIReportUrl4="https://app.powerbi.com/reportEmbed?reportId=53e9a5f1-12fd-4ff0-94e1-ba0bf36c43bd&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
    powerBIReportUrl5="https://app.powerbi.com/reportEmbed?reportId=be370fcd-d283-42ae-855f-8ec1e3fd08b3&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
powerBIReportUrl6="https://app.powerbi.com/reportEmbed?reportId=f725e3c0-a108-4a04-8f52-982eceadf67f&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
powerBIReportUrl7="https://app.powerbi.com/reportEmbed?reportId=81d2e82d-c0ce-42b2-84ae-b015c8c217d5&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";
powerBIReportUrl8="https://app.powerbi.com/reportEmbed?reportId=d0fcec2a-4b95-46a2-a4f1-0ebe926c72d6&autoAuth=true&ctid=da93d1de-7903-4a96-bf2a-f39c3774312b";

    handleClick1() {
        //this.showPowerBIReport = !this.showPowerBIReport; 
        window.open(this.powerBIReportUrl1, '_blank', 'width=1200,height=800');
    }

    handleClick4(){
      // this.showPowerBIReport2=!this.showPowerBIReport2;
      window.open(this.powerBIReportUrl2, '_blank', 'width=1200,height=800');
    }
    handleClick3(){
      window.open(this.powerBIReportUrl3, '_blank', 'width=1200,height=800');
    }
    handleClick5(){
      window.open(this.powerBIReportUrl4, '_blank', 'width=1200,height=800');
    }
    handleClick6(){
      window.open(this.powerBIReportUrl5, '_blank', 'width=1200,height=800');

    }
    handleClick7(){
 window.open(this.powerBIReportUrl6, '_blank', 'width=1200,height=800');
    }
    handleClick8(){
      window.open(this.powerBIReportUrl7,'_blank', 'width=1200,height=800')
    }
    handleClick9(){
      window.open(this.powerBIReportUrl8,'_blank', 'width=1200,height=800')
    }
}