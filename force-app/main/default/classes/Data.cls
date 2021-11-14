public class Data {
    class DataException extends Exception{}
    public static void createRecords(Integer num){
        if(num<8 || num>1700)
            throw new DataException('bad num');
        List<Account> acc = new List<Account>();
        List<Product2> pro = new List<Product2>();
        for(Integer i=1; i<=num; i++){
            acc.add(new Account(Name='Acc'+i, AnnualRevenue=200000+i*50000, WebSite='agility-app-7614-dev-ed'));
            pro.add(new Product2(Name='Pro'+i, ProductCode='p'+i, DisplayUrl='playful-narwhal-a6hcpa-dev-ed'));
        }
        insert acc;
        insert pro;
        List<Opportunity> opp = new List<Opportunity>();
        List<PricebookEntry> pbe = new List<PricebookEntry>();
        String[] s = new String[]{'Prospecting', 'Proposal/Price Quote', 'Closed Won'};
        Id pb = [select Id from Pricebook2 limit 1].Id;
        for(Integer i=1; i<=num; i++){
            for(Integer j=0; j<Math.mod(i, 4); j++)
            	opp.add(new Opportunity(AccountId=acc[i-1].Id, Name='Acc'+i+'Opp'+j, StageName=s[j], CloseDate=Date.today(),
                Amount=j*20000+i*5000, Pricebook2Id=pb));
            pbe.add(new PricebookEntry(Pricebook2Id=pb, Product2Id=pro[i-1].Id, UnitPrice=5, IsActive=true));
        }
        insert opp;
        insert pbe;
        List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
        Integer len = opp.size();
        for(Integer i=1; i<=len; i++)
            for(Integer j=0; j<Math.mod(i, 4); j++)
            	oli.add(new OpportunityLineItem(OpportunityId=opp[i-1].Id, Product2Id=pro[Math.mod(i + j, num)].Id,
                Quantity=2, TotalPrice=20000+i*5000));
        insert oli;
    }
    public static void deleteRecords(){
        delete [select Id from OpportunityLineItem];
        delete [select Id from Opportunity];
        delete [select Id from PricebookEntry where Name!=NULL];
        delete [select Id from Product2];
        delete [select Id from Account];
    }
}