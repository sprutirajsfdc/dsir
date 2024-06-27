@isTest
public class ProjectUnitsControllerTest {
    @isTest
    static void testGetProjects() {
        // Create test data
        List<CD_Project__c> projects = new List<CD_Project__c>();
        Set<String> testProjectNames = new Set<String> {
            'Ritz Carlton Residences Business Bay', 
            'The Private Residences DIFC', 
            'Zabeel Saray Villas', 
            'Ritz Carlton Ras Al Khaimah', 
            'Eden house Canal', 
            'Golden Tower',
            'Corinthia Diriyah', 
            'The Lancelot Collection', 
            'Cityscape', 
            'Four Seasons Abu Dhabi at Al Maryah Island', 
            'The Ritz Carlton Diriyah', 
            'Knightsbridge Gate', 
            'Raffles Jeddah', 
            'Baccarat Diriyah', 
            'Canal Front', 
            'Eden Hills', 
            'Nobu Residences', 
            'Rouge by Baccarat', 
            'Dubai Harbour', 
            'One & Only Penthouses', 
            'DMCC uptown', 
            'Seaside Hills', 
            'Nobu Residences Tower B', 
            'Nobu Residences Villas', 
            'Nobu Residences Tower A', 
            'Baccarat Residences', 
            'Wasl', 
            'One & Only', 
            'One Zaabeel', 
            'Beach Hills Villas'
        };

        for(String projectName : testProjectNames) {
            projects.add(new CD_Project__c(Name = projectName));
        }
        insert projects;

        Test.startTest();
        // Call the controller method
        List<CD_Project__c> result = ProjectUnitsController.getProjects();
        Test.stopTest();

        // Verify the results
        System.assertEquals(testProjectNames.size(), result.size(), 'Incorrect number of projects returned');
        for(CD_Project__c project : result) {
            System.assert(testProjectNames.contains(project.Name), 'Project name not found in expected list');
        }
    }
}