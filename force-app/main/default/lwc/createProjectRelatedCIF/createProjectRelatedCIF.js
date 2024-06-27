import { LightningElement,track,api} from 'lwc';
import CIF_OBJECT from '@salesforce/schema/CIF__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AGENCY_NAME from '@salesforce/schema/CIF__c.x3rd_Party_Agency_Name__c';
import AGENT_NAME from '@salesforce/schema/CIF__c.x3rd_Party_Agent_Name__c';
import AGENCY_RERA_NUMBER from '@salesforce/schema/CIF__c.x3rd_Party_Agency_Rera_Number__c';
import AGENT_BRN from '@salesforce/schema/CIF__c.x3rd_Party_Agent_Number__c';
import AGENT_MOBILE from '@salesforce/schema/CIF__c.x3rd_Party_Agent_Mobile__c';
import AGENT_EMAIL from '@salesforce/schema/CIF__c.x3rd_Party_Agent_Email__c';
import NAME_OF_THE_OWNER from '@salesforce/schema/CIF__c.NAME_OF_THE_OWNER__c';
import JOINT_OWNER from '@salesforce/schema/CIF__c.JOINT_OWNER__c';
import MOBILE_COUNTRY_CODE from '@salesforce/schema/CIF__c.Mobile_Country_Code__c';
import MOBILE from '@salesforce/schema/CIF__c.Mobile__c'; 
import EMAIL from '@salesforce/schema/CIF__c.E_MAIL__c';
import HOW_DID_YOU_HEAR_ABOUT_US from '@salesforce/schema/CIF__c.CIF_Lead_Source__c';
import UNIT_TYPE from '@salesforce/schema/CIF__c.Unit_Type__c';
import PREFERRED_PAYMENT_METHOD from '@salesforce/schema/CIF__c.Preferred_Payment_Method__c';
import HOW_WOULD_YOU_LIKE_US_TO_CONTACT_YOU from '@salesforce/schema/CIF__c.How_Would_You_Like_Us_To_Contact_You__c';
import USER_GENERATED_CIF from '@salesforce/schema/CIF__c.User_Generated_CIF__c';
import COMMENTS from '@salesforce/schema/CIF__c.Comments__c';
import CIFID from '@salesforce/schema/CIF__c.Id';
import PROJECT from '@salesforce/schema/CIF__c.Project__c';
import CIF_TYPE from '@salesforce/schema/CIF__c.CIF_Type__c';
import REQUEST_TO_CREATE from '@salesforce/schema/CIF__c.Request_To_Create__c';
import SHARING_REGION from '@salesforce/schema/CIF__c.Region__c';
import strUserId from '@salesforce/user/Id';
import createProjectRelatedCIF from '@salesforce/resourceUrl/createCIFCSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import { CurrentPageReference } from 'lightning/navigation';

export default class CreateProjectRelatedCIF extends LightningElement {

cifForm = true;
@api projectId;
@track selectedOption = '';
@track showAgencyBriefingForm = false;
@track showAgencyBuyerForm = false;
@track showDirectBuyerForm = false;
@track showSubmit = false;
@track isLoading = true;
activeSections = ['A'];
activeSectionsMessage = '';
@api isMobile = false;
@api prop2;
@api prop1;
@api prop3;
@api recordId;
@api request_create; 
@api isLoaded= false;
objectApiName = CIF_OBJECT;
agencyName = AGENCY_NAME;
agentName = AGENT_NAME;
agencyReraNumber = AGENCY_RERA_NUMBER;
agentBRN = AGENT_BRN;
agentMobile = AGENT_MOBILE;
agentEmail = AGENT_EMAIL;
nameOfOwner = NAME_OF_THE_OWNER;
jointOwner = JOINT_OWNER;
mobileCountryCode = MOBILE_COUNTRY_CODE;
mobile = MOBILE;
email = EMAIL;
leadsource = HOW_DID_YOU_HEAR_ABOUT_US;
unitType = UNIT_TYPE;
paymentMethod = PREFERRED_PAYMENT_METHOD;
contact = HOW_WOULD_YOU_LIKE_US_TO_CONTACT_YOU;
userGenrated = USER_GENERATED_CIF;
cif_Id = '';
idcif = CIFID;
project = PROJECT;
commentsField = COMMENTS;
cif_type = CIF_TYPE;
request_create = REQUEST_TO_CREATE;
sharing_reg = SHARING_REGION;
thankYouPage = false;
// showForm = false;


calculateGridColumnClass() {
// Dynamically decide the grid column class based on the screen size
if (window.innerWidth >= 1024) {
    return 'slds-col slds-size_1-of-3';
} else {
    return 'slds-col slds-size_1-of-2';
}
}

// @track isMobileView = false;
// @track isDesktop = true; // Default to desktop view
//     connectedCallback() {
//         loadStyle(this, createProjectRelatedCIF); 
//         this.template.addEventListener('contextmenu', this.handleRightClick.bind(this));
//         // Check the device width to determine if it's a desktop or not
//         this.handleWindowResize(); // Call the function on component initialization
//         window.addEventListener('resize', this.handleWindowResize);
//     }
//     handleWindowResize() {
//         const isMobile = window.innerWidth <= 768;
//         this.isDesktop = !isMobile;
//     }

connectedCallback(){
    loadStyle(this, createProjectRelatedCIF);
    this.template.addEventListener('contextmenu', this.handleRightClick.bind(this));
    setTimeout(() => {
    this.isLoaded = true;
    }, 1000);
    // if(location.reload()){
    //    alert('Please Wait while Loading...');
    // }
// const styles = '      .custom-radio-group input[type="radio"]  {       transform: scale(5) !important;    }     ';

//     // Create a style element margin-right: 30px !important;  display: flex !important;  flex-direction: row !important;
//     const styleElement = document.createElement('style');
//     styleElement.innerHTML = styles;

//     // Append the style element to the component's shadow DOM
//     document.head.appendChild(styleElement);
    

}
// handleFormLoad(){
//     this.isLoaded = true;
// }
handleRightClick(event) {
// Prevent the default right-click behavior
event.preventDefault();
// Optionally, you can add custom logic here to handle the right-click event
console.log('Right-click is disabled on this page.');
// You can also show a message or perform any other actions.
}

userId = strUserId;
agencyN = 'AGENCY NAME (REQUIRED)';
agencyReraN = "AGENCY RERA NUMBER (OPTIONAL)";
agencyBRN = "AGENT BRN (OPTIONAL)";
agentN = "AGENT NAME (REQUIRED)";
agencyMob = "AGENT MOBILE (REQUIRED)";
agentE = "AGENT EMAIL (REQUIRED)";
country = "COUNTRY (REQUIRED)";
cifUser = "USER GENERATED CIF";
comments = 'COMMENTS IF ANY (OPTIONAL)';
cont = "HOW WOULD YOU LIKE US TO CONTACT YOU? (OPTIONAL)";
payment = "PREFERRED PAYMENT METHOD ? (OPTIONAL)";
unitTy = "UNIT TYPE (OPTIONAL)";
hearAbout = "HOW DID YOU HEAR ABOUT US? (REQUIRED)";
mail = "E-MAIL (REQUIRED)";
mob = "MOBILE (REQUIRED)";
mobCountry =  "MOBILE COUNTRY CODE (OPTIONAL)";
joint = "JOINT OWNER (OPTIONAL)";
nameOwner = "NAME OF THE OWNER (REQUIRED)";
requestCreate = "REQUEST TO CREATE";

handleLookupSelection(event){
if(event.detail.selectedRecord != undefined){
    console.log('Selected Record Value on Parent Component is ' +  
    JSON.stringify(event.detail.selectedRecord));
    //alert(event.detail.selectedRecord.Id + ' '+ event.detail.selectedRecord.Name);
    this.userGenrated = event.detail.selectedRecord.Id;
    console.log('this.userGenrated',this.userGenrated);      
}
}
handleBackButton(){
this.thankYouPage = false;
// this.cifForm = true;
location.reload(); 
}
handleSuccess(event) {
try{
    this.isLoaded = false;
    setTimeout(() => {
            this.isLoaded = true;
        }, 1000);
this.cif_Id = event.detail.id;
const CIFRecordId = event.detail.id;
console.log('Newly created record ID:', CIFRecordId);
//alert('CIF Created '+event.detail.id);
this.cifForm = false;
this.thankYouPage = true;
// location.reload();
}catch(error){
    console.log('error',error);
}
}  
handleError(event){
    const scrollOptions = {
        left: 0,
        top: 0,
        behavior: 'smooth'
    }
    window.scrollTo(scrollOptions);
}
// topFunction(){
//     const scrollOptions = {
//         left: 0,
//         top: 0,
//         behavior: 'smooth'
//     }
//     window.scrollTo(scrollOptions);
//     this.handleSubmit();
// }
handleSubmit(event) {
  
    window.scrollTo({
        top: 0,
        behavior: 'smooth' // Optional: Use smooth scrolling animation
    });
    // this.isLoaded = false;
    // setTimeout(() => {
    //     this.isLoaded = false;
    // }, 2000);
    // setTimeout(() => {
    //     this.isLoaded = true;
    // }, 2000);
event.preventDefault();
 try{
const fields = event.detail.fields;
// console.log('field....====', JSON.stringify(fields));
fields.User_Generated_CIF__c = this.userGenrated;
// console.log('update user............'+fields.User_Generated_CIF__c+'++++=');
fields.Project__c = this.projectId;
fields.CIF_Type__c = this.selectedOption;
const userLookup = fields.User_Generated_CIF__c;
// console.log('userLookup.............',!userLookup);
if(this.userGenrated == '[object Object]'){
    // this.isLoaded = false;
    // setTimeout(() => {
    //         this.isLoaded = true;
    //     }, 2000);
    // console.log('this.userLookup is null........'+this.userGenrated);
    // console.log('null.............',this.userLookup);
    alert('User Generated CIF is required.');   
}else{
    // console.log('submitted.............',);
    const form = this.template.querySelector('lightning-record-edit-form').submit(fields);
    if (form) {
        form.submit();
    }
}
this.isLoading = false;
}catch(error){
        console.log('error',error);
}
// if (Object.keys(fields.User_Generated_CIF__c).length === 0) {
//     isLookupRequired = false;
//     console.log('!fields.User_Generated_CIF__c '+!fields.User_Generated_CIF__c);
//     console.log('this.isLookupRequired: '+this.isLookupRequired);
// }
// else{
//     this.isLookupRequired = true;
//     console.log('this.isLookupRequired: '+this.isLookupRequired);
// }

// if (Object.keys(fields.User_Generated_CIF__c).length === 0) {
//     alert('User Generated CIF is required.');
//      console.log('fields.User_Generated_CIF__c: (if part)---'+fields.User_Generated_CIF__c);
// }
// else{
//     alert('testing...');
//     console.log('fields.User_Generated_CIF__c: (else part)---'+fields.User_Generated_CIF__c);
//     this.template.querySelector('lightning-record-edit-form').submit(fields);
// }
// 
}

get options() {
return [
    { label: 'AGENCY BRIEFING', value: 'AGENCY BRIEFING' },
    { label: 'AGENCY BUYER', value: 'AGENCY BUYER' },
    { label: 'DIRECT BUYER', value: 'DIRECT BUYER' }
    // { label: 'CONTACT REQUEST', value: 'CONTACT REQUEST' }
];
}

handleRadioChange(event) {
// this.showForm = true;
this.selectedOption = event.detail.value;
if (this.selectedOption === 'AGENCY BRIEFING') {
    this.showAgencyBriefingForm = true;
    this.showAgencyBuyerForm = false;
    this.showDirectBuyerForm = false;
    this.showSubmit = false;
} else if (this.selectedOption === 'AGENCY BUYER') {
    this.showAgencyBriefingForm = false;
    this.showAgencyBuyerForm = true;
    this.showDirectBuyerForm = false;
    this.showSubmit = false;
}else if (this.selectedOption === 'DIRECT BUYER') {
    this.showAgencyBriefingForm = false;
    this.showAgencyBuyerForm = false;
    this.showDirectBuyerForm = true;
    this.showSubmit = false;
}else if (this.selectedOption === 'CONTACT REQUEST') {
    this.showAgencyBriefingForm = false;
    this.showAgencyBuyerForm = false;
    this.showDirectBuyerForm = false;
    this.showSubmit = true;
}
}



handleSectionToggle(event) {
const openSections = event.detail.openSections;

if (openSections.length === 0) {
    this.activeSectionsMessage = 'All sections are closed';
} else {
    this.activeSectionsMessage =
        'Open sections: ' + openSections.join(', ');
}
} 

}