public with sharing class PicklistValuesController {
    @AuraEnabled(cacheable=true)
    public static List<ComboOption> getPicklistValues(String objectApiName, String fieldApiName) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(objectApiName);
        if(sobjType == null){
            System.debug('Return'+objectApiName);
            return new List<ComboOption>();
        }
        Schema.DescribeSObjectResult describeSObjectResult = sobjType.getDescribe();
        Schema.DescribeFieldResult fieldResult = describeSObjectResult.fields.getMap().get(fieldApiName).getDescribe();
       

        List<ComboOption> options = new List<ComboOption>();
        for (Schema.PicklistEntry pe : fieldResult.getPicklistValues()) {
            options.add(new ComboOption(pe.getLabel(), pe.getValue()));
        }
        return options;
    }

    public class ComboOption {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}

        public ComboOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}