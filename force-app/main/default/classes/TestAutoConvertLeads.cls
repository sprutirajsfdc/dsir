@isTest 
      public class TestAutoConvertLeads{
      static testMethod void createnewlead() {
      User userToCreate = [Select id from user where profile.name='PB Administrator' Limit 1];
      
      Test.startTest();    
      Lead leadToCreate =new Lead();
      List<id> Ids= New List<Id>();
      leadToCreate.ownerid= userToCreate.id;
      leadToCreate.LastName ='Gupta';
      leadToCreate.Company='Salesforce';
      leadToCreate.LeadSource='Partner Referral';
      leadToCreate.Rating='';
      leadToCreate.Status='';
     // leadToCreate.Phone = '1234567890';
      leadToCreate.Email = 'dr@gmail.com';
      insert leadToCreate; 
      
      Ids.add(leadToCreate.id);
      AutoConvertLeads.LeadAssign(Ids);
      
      Test.stopTest();
   }
}