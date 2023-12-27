/**
 * @description       : 
 * @author            : patrick@devforcelabs.com.br | 27 99241-5014
 * @group             : 
 * @last modified on  : 12-27-2023
 * @last modified by  : patrick@devforcelabs.com.br | 27 99241-5014 
 * Modifications Log
 * Ver   Date         Author                                        Modification
 * 1.0   12-27-2023   patrick@devforcelabs.com.br | 27 99241-5014   Initial Version
**/
@isTest
public class AccountLimpezaBatchTest {

    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        List<Task> tasks = new List<Task>();
        List<Opportunity> opportunities = new List<Opportunity>();

        for(Integer i=0; i<20; i++){
            accounts.add(new Account(Name='Acc Test '+i));
        }
        insert accounts;

        for(Account acc: [SELECT Id FROM Account]){
            for(Integer i=0; i<10; i++){
                tasks.add(new Task(WhatId = acc.Id, ActivityDate = Date.today()+100));
            }
            for(Integer j=10; j<20; j++){
                opportunities.add(new Opportunity(AccountId = acc.Id, Name = 'Opp Test '+j, StageName = 'Closed Won', CloseDate = Date.today()+130));
            }
        }
        insert tasks;
        insert opportunities;
    }

    @isTest
    static void AccountInactiveTest() {

        Test.startTest();
        AccountInactive accInactive = new AccountInactive();
        Id batchId = Database.executeBatch(accInactive);
        Test.stopTest();

        System.assertEquals(20, [SELECT COUNT() FROM Account WHERE Inativa__c = true]);
    }

}