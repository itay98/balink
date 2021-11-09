import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
export default class DynamicList extends LightningElement {
    @api recordId;
    //@api objectApiName;
    @wire(getObjectInfo, { recordId: '$recordId' })
    children(res){
        console.log(res,this)
    };
}