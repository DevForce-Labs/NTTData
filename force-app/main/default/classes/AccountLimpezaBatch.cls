/**
 * @description       :
 * @author            : patrick@devforcelabs.com.br | 27 99241-5014
 * @group             :
 * @last modified on  : 12-27-2023
 * @last modified by  : patrick@devforcelabs.com.br | 27 99241-5014
 * Modifications Log
 * Ver   Date         Author                                        Modification
 * 1.0   12-23-2023   patrick@devforcelabs.com.br | 27 99241-5014   Initial Version
 **/

public class AccountLimpezaBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, (SELECT Id FROM Tasks WHERE CreatedDate > LAST_N_DAYS:90 OR ActivityDate > LAST_N_DAYS:90), (SELECT Id FROM Opportunities WHERE (StageName = \'Closed Won\' AND CloseDate > LAST_N_DAYS:120) OR StageName != \'Negotiation/Review\') FROM Account';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> records){
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : records) {
            acc.Inativa__c = true;
            accountsToUpdate.add(acc);
            // if (acc.Tasks.isEmpty() && acc.Opportunities.isEmpty()) {
            //     acc.Inativa__c = true;
            // }
        }

        if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc){}

}