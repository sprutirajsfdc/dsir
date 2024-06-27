/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Property_ValuationTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Property_ValuationTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Property_Valuation__c());
    }
}