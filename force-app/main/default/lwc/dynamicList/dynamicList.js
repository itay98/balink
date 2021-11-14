import { LightningElement, api } from 'lwc';
import getList from "@salesforce/apex/DynamicListController.getList";
const ps = [{ label: 10, value: 10 }, { label: 20, value: 20 }, { label: 30, value: 30 }];
export default class DynamicList extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api mainObj;
    @api fields;
    @api rln;
    @api cond;
    err;
    records;
    columns;
    pageSize = ps[0].value;
    pageNum = 1;
    total;
    numOpt;
    last;
    sizeOpt = ps;
    get offset() {
        return this.pageSize * (this.pageNum - 1);
    }
    get data() {
        return this.records.slice(this.offset, this.pageSize * this.pageNum);
    }
    setNums(){
        this.last = Math.ceil(this.total / this.pageSize);
        this.numOpt = [];
        for (let i = 1; i <= this.last; i++)
            this.numOpt.push({ label: i, value: i });
    }
    connectedCallback() {
        if (this.fields.includes('('))
            this.err = 'Invalid fields';
        else {
            const { recordId, objectApiName, mainObj, fields, rln, cond } = this;
            getList({ objName: objectApiName || mainObj, fields, recordId, flag: rln || cond })
                .then(res => {
                    if (typeof res === 'string')
                        this.err = res;
                    else {
                        this.columns = res.columns;
                        this.records = res.records;
                        this.total = this.records.length;
                        this.setNums();
                    }
                }).catch(e => this.err = e.statusText)
        }
    }
    pageNumChange(e) {
        this.pageNum = parseInt(e.detail.value);
    }
    pageSizeChange(e) {
        let newSize = parseInt(e.detail.value);
        this.pageNum = Math.floor(this.offset / newSize) + 1;
        this.pageSize = newSize;
        this.setNums();
    }
    moveToFirst() {
        this.pageNum = 1;
    }
    moveToLast() {
        this.pageNum = this.last;
    }
}