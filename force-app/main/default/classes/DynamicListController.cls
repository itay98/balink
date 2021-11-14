public with sharing class DynamicListController {
    @AuraEnabled
    public static Object getList(String objName, String fields, Id recordId, String flag){
        try{
            String query = 'select ' + fields + ' from ';
            DescribeSObjectResult dor = Schema.describeSObjects(new String[]{ objName })[0];
            if(recordId != null){
                String fieldName;
                for(ChildRelationship c : dor.getChildRelationships())
                    if(c.relationshipname == flag){
                        dor = c.childsobject.getDescribe();
                        fieldName = c.field.getDescribe().name;
                        objName = dor.name;
                        break;
                    }
                query += objName + ' where ' + fieldName + '=\'' + recordId + '\'';
            } else{
                query += objName;
                if(flag != null)
                    query += ' where ' + flag;
            }
            List<SObject> rec = Security.stripInaccessible(AccessType.READABLE, Database.query(query)).getRecords();
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
