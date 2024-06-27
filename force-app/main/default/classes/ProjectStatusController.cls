public with sharing class ProjectStatusController {
    public List<UnitWrapper> availableUnits { get; set; }
    public Boolean showAvailableUnits { get; set; }
    public String selectedProjectId { get; set; }
    public List<SelectOption> projects { get; set; }
    public String selectedUnitId { get; set; }
    public String projectName { get; set; }
    
    public class UnitWrapper {
        public CD_Property__c unit { get; set; }
        public Boolean isSelected { get; set; }
        
        public UnitWrapper(CD_Property__c u) {
            unit = u;
            isSelected = false;
        }
    }
    
    public void fetchAvailableUnits() {
        if(String.isNotBlank(selectedProjectId)) {
            // Query to retrieve available units with status for the selected project
            List<CD_Property__c> units = [SELECT Id, Name, Status__c FROM CD_Property__c WHERE CD_Project__c = :selectedProjectId AND Status__c = 'Available' WITH SECURITY_ENFORCED];
            availableUnits = new List<UnitWrapper>();
            for (CD_Property__c unit : units) {
                availableUnits.add(new UnitWrapper(unit));
            }
            showAvailableUnits = true;
            projectName = [SELECT Name FROM CD_Project__c WHERE Id = :selectedProjectId].Name;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a project.'));
            showAvailableUnits = false;
        }
    }
     
    
    public ProjectStatusController(ApexPages.StandardController controller) {
        projects = new List<SelectOption>();
        for(CD_Project__c proj : [SELECT Id, Name FROM CD_Project__c WITH SECURITY_ENFORCED]) {
            projects.add(new SelectOption(proj.Id, proj.Name));
        }
    }
    public PageReference createRecord() {
        String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); // Retrieve the selected record type from the URL parameter
        String newRecordUrl = '/lightning/o/RA_Request_Form__c/new?recordTypeId=' + recordTypeId + '&nooverride=1';
        if (selectedUnitId != null) {
            newRecordUrl += '&def_lkid=' + selectedUnitId;        
        }
        return new PageReference(newRecordUrl);
    }
    
}