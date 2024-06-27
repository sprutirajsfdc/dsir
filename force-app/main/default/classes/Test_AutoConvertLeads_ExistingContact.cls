@isTest 
public class Test_AutoConvertLeads_ExistingContact{
    static testMethod void createnewlead() {
        User userToCreate = [Select id from user where profile.name='PB Administrator' Limit 1];
        
        Test.startTest();  
        
        //Create Account
            List<Account> AccountList = new List<Account>();
            Account  AccountObj = new Account();
            AccountObj.Name ='test';
            AccountList.add(AccountObj);
            insert AccountList;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'dr@gmail.com',
            accountId = AccountList[0].Id
        );
        insert testContact;
        
        Lead leadToCreate =new Lead();
        List<id> Ids= New List<Id>();
        leadToCreate.ownerid= userToCreate.id;
        leadToCreate.LastName ='Gupta';
        leadToCreate.Company='Salesforce';
        leadToCreate.LeadSource='Partner Referral';
        leadToCreate.Rating='';
        leadToCreate.Status='';
        // leadToCreate.Phone = '1234567890';
        leadToCreate.Email = 'dr2@gmail.com';
        insert leadToCreate; 
        
        Ids.add(leadToCreate.id);
        List<AutoConvertLeads_ExistingContact.variableInnerClass> innerClassList = new List<AutoConvertLeads_ExistingContact.variableInnerClass>();
    	AutoConvertLeads_ExistingContact.variableInnerClass obj1 = new AutoConvertLeads_ExistingContact.variableInnerClass();
        obj1.objLead = leadToCreate;
        obj1.objContact = testContact;
        innerClassList.add(obj1);
        AutoConvertLeads_ExistingContact.leadConvertInto_existingContact(innerClassList);
        Test.stopTest();
    }
}