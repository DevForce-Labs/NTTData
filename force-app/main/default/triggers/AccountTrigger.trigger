/**
 * @description       :
 * @author            : patrick@devforcelabs.com.br | 27 99241-5014
 * @group             :
 * @last modified on  : 12-26-2023
 * @last modified by  : patrick@devforcelabs.com.br | 27 99241-5014
 * Modifications Log
 * Ver   Date         Author                                        Modification
 * 1.0   12-22-2023   patrick@devforcelabs.com.br | 27 99241-5014   Initial Version
 **/
trigger AccountTrigger on Account(after insert, before insert) {
  if (Trigger.isBefore && Trigger.isInsert) {
    AccountTriggerHandler.handleBeforeInsert(Trigger.new);
  }

  if (Trigger.isAfter && Trigger.isInsert) {
    AccountTriggerHandler.handleAfterInsert(Trigger.new);
  }

}
