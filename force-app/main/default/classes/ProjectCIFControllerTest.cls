@isTest
public class ProjectCIFControllerTest {

    @isTest
    static void testProjectCIFController() {
        // Create a test CD_Project__c record
        CD_Project__c testProject = new CD_Project__c(Name = 'Test Project');
        insert testProject;

        // Set up the test page and controller
        PageReference pageRef = new PageReference('/apex/YourPageName'); // Replace YourPageName with the actual name of your Visualforce page
        pageRef.getParameters().put('id', testProject.Id);
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testProject);
        ProjectCIFController controller = new ProjectCIFController(stdController);

        // Verify that the controller properties are set correctly
        System.assertEquals(testProject.Id, controller.MstrId);
        System.assertEquals(testProject.Id, controller.proObj.Id);

        // Call the projectId method and verify the result
        String projectIdResult = controller.projectId();
        System.assertEquals('project id is  (' + testProject.Id + ')', projectIdResult);
    }
}