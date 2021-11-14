public with sharing class TopOppsController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getList(Datetime created){
        return [select Name, StageName, CloseDate, Amount from Opportunity where Amount!=null order by Amount desc limit 10];
    }
}
