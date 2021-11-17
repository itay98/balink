public with sharing class DynamicListController {
    @AuraEnabled
    public static Object getList(String objName, String fields, Id recordId, String flag){
        try{
            String query = 'select ';
            DescribeSObjectResult dor;
            if(recordId == null){
                query += fields + ' from ' + objName;
                if(flag != null)
                    query += ' where ' + flag;
                dor = Schema.describeSObjects(new String[]{ objName })[0];
            } else
                query += '(select ' + fields + ' from ' + flag + ') from ' + objName + ' where Id=\'' + recordId + '\'';
            List<SObject> rec = Security.stripInaccessible(AccessType.READABLE, Database.query(query)).getRecords();  
            if(recordId != null){
                rec = rec[0].get(flag);
                dor = rec.getSObjectType().getDescribe();
            }
            List<Map<String, String>> col = new List<Map<String, String>>();
            Map<String, SObjectField> fMap = dor.fields.getMap();
            for(String n : fields.split(',')){
                DescribeFieldResult dfr = fMap.get(n.trim()).getDescribe();
                col.add(new Map<String, String>{ 'fieldName'=>dfr.name, 'label'=>dfr.label });
            }
            return new Map<String, Object>{ 'records'=>rec, 'columns'=>col };
        } catch(Exception e){
            return e.getMessage();
        }
    }
}
