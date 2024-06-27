public class ProjectCIFController {
    
    public String MstrId{get;set;}
    public CD_Project__c proObj{get;set;}
    public ProjectCIFController(ApexPages.StandardController Controller){
       
        MstrId = ApexPages.currentPage().getParameters().get('id'); 
        proObj = [Select Id, Name From CD_Project__c where Id =: MstrId];
        
    }
    public String projectId() {
            return 'project id is  (' + proObj.id + ')';
    }
    

}