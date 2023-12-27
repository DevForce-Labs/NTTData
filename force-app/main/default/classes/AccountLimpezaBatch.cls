/**
 * @description       :
 * @author            : patrick@devforcelabs.com.br | 27 99241-5014
 * @group             :
 * @last modified on  : 12-26-2023
 * @last modified by  : patrick@devforcelabs.com.br | 27 99241-5014
 * Modifications Log
 * Ver   Date         Author                                        Modification
 * 1.0   12-23-2023   patrick@devforcelabs.com.br | 27 99241-5014   Initial Version
 **/

global class AccountLimpezaBatch implements Database.Batchable<SObject>, Schedulable {
  global Database.QueryLocator start(Database.BatchableContext bc) {
    String query = 'SELECT Id, (SELECT Id FROM Tasks WHERE CreatedDate > LAST_N_DAYS:90), (SELECT Id FROM Opportunities WHERE StageName = \'Closed Won\' AND CloseDate > LAST_N_DAYS:120), (SELECT Id FROM Opportunities WHERE StageName = \'Negotiation/Review\') FROM Account';
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext bc, List<Account> records) {
    List<Account> accountsToUpdate = new List<Account>();
    for (Account acc : records) {
      if (acc.Tasks.isEmpty() && acc.Opportunities.isEmpty()) {
        acc.Inativa__c = true;
        accountsToUpdate.add(acc);
      }
    }

    if (!accountsToUpdate.isEmpty()) {
      update accountsToUpdate;
    }
  }

  global void finish(Database.BatchableContext bc) {
  }

  global void execute(SchedulableContext sc) {
    AccountLimpezaBatch batch = new AccountLimpezaBatch();
    Database.executeBatch(batch);
  }
}
