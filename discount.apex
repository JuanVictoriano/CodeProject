trigger ApplicationBeforeInsert on Application__c (before insert, before update) {
    for (Application__c app : Trigger.new) {
        if (app.Permanent_Mailing_Address_State__c == 'State') { // replace 'State' with 2-letter abbreviation, ex: 'NY'
            app.Discount__c = 'Yes';
        }
        // If the state is not included in line 3, no changes are made, allowing the default system process to handle it
    }
}
