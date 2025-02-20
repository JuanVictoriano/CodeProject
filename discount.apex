trigger ApplicationBeforeInsert on Application__c (before insert, before update) {
    for (Application__c app : Trigger.new) {
        if (app.Permanent_Mailing_Address_State__c == 'NY') {
            app.Discount__c = 'Yes';
        }
        // If the state is not 'NY', no changes are made, allowing the default system process to handle it
    }
}
