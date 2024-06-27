/**
* @description   This Apex class provides methods for searching existing contacts, 
*                creating new contacts, and fetching picklist values for a specified object field.
* @author        Sprutiraj
* Modification Log:
* Ver   Date         Author                Modification
* 1.0   12/1/2024   Sprutiraj             Initial Version
*/
public class ConSearchcontroller {
    public Contact newContact { get; set; }
    public List<Contact> duplicateContacts { get; set; }
    public Boolean showDuplicateContacts { get; set; }
    
    public ConSearchcontroller(ApexPages.StandardController stdController) {
        newContact = (Contact)stdController.getRecord();
        newContact = new Contact();
        duplicateContacts = new List<Contact>();
        showDuplicateContacts = false;
        
    }
    
    public PageReference saveContact() {
   
        if (String.isBlank(newContact.Email) && String.isBlank(newContact.Phone) && String.isBlank(newContact.MobilePhone)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide at least one of the following: Email, Phone, or Mobile Phone.'));
            return null;
        }
        // Check for duplicates by last name
        String lastName = newContact.LastName;
        String fuzzyLastName = '%' + lastName + '%';
        String phone =newContact.Phone;
        String email=newContact.Email;
        String mobilephone=newContact.MobilePhone;
        if (String.isBlank(phone)) {
            phone = null;
        }
        if (String.isBlank(email)) {
            email = null;
        }
        if (String.isBlank(mobilephone)) {
            mobilephone = null;
        }
        if(newContact != null){
            if (newContact.Id != null) {
                duplicateContacts = [SELECT Id, Salutation, RecordType.Name,Phone_Country_Code__c,Other_Email__c, Name,Mobile_Country_Codes__c, pba__CompanyName__c, Email, Phone, MobilePhone, ContactType__c	, Sharing_Rule__c	, LeadSource 
                                     FROM Contact 
                                     WHERE Id != :newContact.Id 
                                     AND (Phone = :phone OR Email = :email OR MobilePhone = :mobilephone OR Phone = :mobilephone OR mobilephone=:Phone)
                                    ];
            } else {
                duplicateContacts = [SELECT Id, Salutation, RecordType.Name, Name,Mobile_Country_Codes__c,Other_Email__c,Phone_Country_Code__c	, pba__CompanyName__c, Email, Phone, MobilePhone, ContactType__c	, Sharing_Rule__c	, LeadSource
                                     FROM Contact 
                                     WHERE Id != :newContact.Id 
                                     AND Phone = :phone 
                                     AND Email = :email 
                                     AND MobilePhone = :mobilephone
                                    ];
            }
            
            if (duplicateContacts.isEmpty()) {
                createOrUpdateAccount();
                insert newContact;
                //newContact = new Contact();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contact saved successfully'));
                //newContact = new Contact(); // Clear the form for the next entry
                PageReference contactDetailPage = new PageReference('/' + newContact.Id);
                contactDetailPage.setRedirect(true);
                return contactDetailPage;
                
            } else {
                showDuplicateContacts = true;
                // Duplicates found, show a message
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Duplicate contacts found.'));
                return null;
            }
        }
        return null;
    }
    public void createOrUpdateAccount() {
        if (String.isNotBlank(newContact.AccountId)) {
            System.debug('AccountId: ' + newContact.AccountId);
            
            // Check if an Account with the specified Company Name already exists
            try {
                Account existingAccount = [SELECT Id FROM Account WHERE Name = :newContact.AccountId LIMIT 1];
                System.debug('Existing Account: ' + existingAccount);
                
                if (existingAccount == null) {
                    // If the Account does not exist, create a new one
                    Account newAccount = new Account(
                        Name = newContact.AccountId
                        // Add other fields as needed
                    );
                    insert newAccount;
                    newContact.AccountId = newAccount.Id;
                    System.debug('New Account created: ' + newAccount.Id);
                } else {
                    // If the Account already exists, link the Contact to the existing Account
                    newContact.AccountId = existingAccount.Id;
                    System.debug('Linking to existing Account: ' + existingAccount.Id);
                }
            } catch (Exception e) {
                System.debug('Error creating/updating Account: ' + e.getMessage());
            }
        }
    }
    
    
    public PageReference cancel() {
        // Redirect to the Contact recent view
        return new PageReference('/lightning/o/Contact/list?filterName=Recent');
    }
}