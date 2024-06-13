public class PaymentController {
 @AuraEnabled(cacheable=true)
    public static List<Payment_Line__c > getPaymentsByOrder() {
        return [SELECT Id ,Order__c , Paid_Amount__c, Paid_date__c, Payment_Date__c, Percentage__c , Name,Mode_of_Payment__c
FROM Payment_Line__c 
WHERE Order__c  IN ('1', '2', '3', '4', '5', '6', '7')
ORDER BY Order__c 
];
    }
    @AuraEnabled
    public static void updatePayments(List<Payment_Line__c > payments) {
        try {
            upsert payments;
        } catch(Exception e) {
            throw new AuraHandledException('Error updating payments: ' + e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Master_plan__c > getPlanOrder2() {
        return [SELECT Id, Order__c , Name FROM Master_plan__c WHERE Order__c  IN ('3', '7', '8', '9') 
ORDER BY Order__c
];
    }
    @AuraEnabled(cacheable=true)
    public static List<Master_plan__c > getplanOrder() {
        return [SELECT Id ,Order__c ,Name FROM Master_plan__c WHERE Order__c  IN ('1', '2', '3', '4', '5', '6', '7')
ORDER BY Order__c 
];
    }
    @AuraEnabled(cacheable=true)
    public static List<OS_Property__c> getUnitDetails() {
        return [SELECT Id, Name FROM OS_Property__c];
    }
   
    }