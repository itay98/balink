import { LightningElement, wire } from 'lwc';
import getList from "@salesforce/apex/TopOppsController.getList";
import { subscribe } from "lightning/empApi";
import AMOUNT from '@salesforce/schema/Opportunity.Amount';
import NAME from '@salesforce/schema/Opportunity.Name';
import CLOSEDATE from '@salesforce/schema/Opportunity.CloseDate';
import STAGENAME from '@salesforce/schema/Opportunity.StageName';
const col = [{ label: 'Name', fieldName: NAME.fieldApiName },
{ label: 'Amount', fieldName: AMOUNT.fieldApiName, type: 'currency' },
{ label: 'Close Date', fieldName: CLOSEDATE.fieldApiName, type: 'date' },
{ label: 'Stage Name', fieldName: STAGENAME.fieldApiName }];
export default class TopOpps extends LightningElement {
    created = new Date();
    sub;
    @wire(getList, { created: '$created' })
    list;
    columns = col;
    connectedCallback() {
        subscribe('/event/Refresh_Top_Opp__e', -1, pe => this.created = pe.data.payload.CreatedDate)
            .then(() => this.sub = true)
    }
}