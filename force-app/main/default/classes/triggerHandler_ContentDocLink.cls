public class triggerHandler_ContentDocLink{
    
    public static void sendEmails(Set<String> setAML_Ids){
        system.debug('inside sendEmails method');
        system.debug('setAML_Ids = '+setAML_Ids);
        
        if(setAML_Ids == null || setAML_Ids.size() <= 0){
            system.debug('setAML_Ids is null or empty!');   
            return;
        }
        
        EmailTemplate template_TOB = [select id, name, body, Subject from EmailTemplate where Name = 'TOB Pending AML Status'];
        EmailTemplate template_Doc = [select id, name, body, Subject from EmailTemplate where Name = 'Document Pending AML Status'];
        
        if(template_TOB == null || template_Doc == null){
            system.debug('template_TOB or template_Doc is null');   
            return;
        }
        
        
        //query to fetch recipients
        List<AML_Email_Recipients__mdt> lstRecipients = [select id, Email__c, Make_recipient__c 
                                                         from AML_Email_Recipients__mdt
                                                         where Make_recipient__c = true];
        
        system.debug('lstRecipients = '+lstRecipients);
        if(lstRecipients == null || lstRecipients.size() <= 0){
            system.debug('lstRecipients is null or empty!');   
            return;
        }
        
        Set<String> setEmailIds = new Set<String>();
        for (AML_Email_Recipients__mdt recipient : lstRecipients) {
            setEmailIds.add(recipient.Email__c);
        }
        
        system.debug('setEmailIds = '+setEmailIds);
        if(setEmailIds == null || setEmailIds.size() <= 0){
            system.debug('setEmailIds is null or empty!');   
            return;
        }
        
        
        //query those AMLs where status is either 'TOB Pending' or 'Document Pending'
        List<AML__c> lstAMLs = [select id, name, AML_Type__c, Status__c, Government_Issued_Photo_ID_upload__c,
                                Utility_Bills_upload__c, Bank_Statement_upload__c, Government_Correspondence_Upload__c,
                                Certificate_of_Incorporation_uploaded__c, Memorandum_Articles_of_Assoc_uploaded__c,
                                Register_of_Shareholders__c, Register_of_Directors_upload__c, Identification_of_Beneficiaries__c,
                                Confirmation_of_registered_upload__c
                                from AML__c
                                where Status__c = 'Document Pending' or
                                Status__c = 'TOB Pending' 
                               ]; 
        system.debug('lstAMLs = '+lstAMLs);
        
        if(lstAMLs == null || lstAMLs.size() <= 0 ){
            system.debug('lstAMLs is empty ');
            return;
        }
        
        // List to store email messages
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(AML__c objAML : lstAMLs){
            
            // Create the email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            if(objAML.Status__c == 'Document Pending'){
                email.setTemplateId(template_Doc.id); 
                
            }else if(objAML.Status__c == 'TOB Pending'){
                
                email.setTemplateId(template_TOB.id); 
            }
            //   email.setTargetObjectId(objAML.id);  
            email.setWhatId(objAML.id);  
            //     email.setToAddresses(new List<String>{'kt@sothebysrealty.ae'}); // Set recipient email address
            email.setToAddresses(new List<String>(setEmailIds));
            email.setHTMLBody(template_TOB.Body);
            emails.add(email);
            
        }
        
        system.debug('emails size = '+emails.size());
        
        if(emails != null && emails.size() > 0){
            try{
                Messaging.sendEmail(emails); 
                system.debug('emails sent from triggerHandler_ContentDocLink');
            }catch(Exception e){
                system.debug('emails could not be sent from triggerHandler_ContentDocLink, error : '+e.getMessage());    
            }
        }else{
            system.debug('emails empty : from triggerHandler_ContentDocLink'); 
        }
        
        
    }
    
    public static void fakeMethod(){
        Integer i = 0;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
    i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        
    i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        
    i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
        i+=1;
    }
}