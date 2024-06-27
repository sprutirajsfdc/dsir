import { LightningElement,wire ,track} from 'lwc';
import getProjects from '@salesforce/apex/ProjectUnitsController.getProjects';
const UNIT_COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Unit Number', fieldName: 'CD_Unit_Number__c' },
    { label: 'Bed Rooms', fieldName: 'CD_No_of_Beds__c' },
    { label: 'Sales Price', fieldName: 'Sales_Price__c' },
    { label: 'View', fieldName: 'CD_View__c' },
    { label: 'Status', fieldName: 'Status__c' }
];

export default class ProjectUnitinv extends LightningElement {
@track projects = [];
@track selectedProjectName;

 unitColumns = UNIT_COLUMNS;
   @track options = [];
   @track unitDetails = [];
   @track prevSelectedProjectName = false;


     @wire(getProjects)
    projectsHandler({ error, data }) {
        if (data) {
            console.log('Projects data:', data);
            this.options = data.map(project => ({ label: project.Name, value: project.Id }));
            this.projects = data.map(project => ({
                ...project,
                showUnits: false,
                Properties__r: project.Properties__r ? [...project.Properties__r] : []
            }));
            this.unitDetails = [...data];
        } else if (error) {
            console.error('Error fetching projects:', error);
        }
    }


    toggleUnits(event) {
        const projectId = event.currentTarget.dataset.id;
       
        this.projects = this.projects.map(project => {
            if (project.Id === projectId) {
                return {...project, showUnits: !project.showUnits};
            }
            return project;
        });
        
    }
handleValueChange(event) {
      console.log('Selected project ID:', event.detail.value);
    if (this.selectedProjectName) {
        this.prevSelectedProjectName = true;
    }
    this.selectedProjectName = event.detail.value;
    console.log('Prev selected project name:', this.prevSelectedProjectName);
    console.log('Selected project name:', this.selectedProjectName);
    this.filterProjectDataHandler();

    }
    filterProjectDataHandler() {
    let filterData = [];
    let tempData = [];
    if (this.prevSelectedProjectName) {
        this.unitDetails = this.fetchedData;
        this.prevSelectedProjectName = false;
    } else if (this.selectedProjectName) { // Add null check for this.options
        let projectName = '';
        for (let i = 0; i < this.options.length; i++) {
            if (this.options[i].value == this.selectedProjectName) {
                projectName = this.options[i].label;
            }
        }
        if (this.fetchedData == this.unitDetails) {
            tempData = this.fetchedData;
        } else {
            tempData = this.unitDetails;
        }
        for (let i = 0; i < tempData.length; i++) {
            if (tempData[i].Name == projectName) {
                filterData.push(tempData[i]);
            }
        }
         //tempData = this.unitDetails;
         //filterData = tempData.filter(item => item.Project_Name__c === projectName);
        this.unitDetails = filterData;
     
    }
}

    
}