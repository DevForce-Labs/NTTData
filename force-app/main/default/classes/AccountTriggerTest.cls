/**
 * @description       :
 * @author            : patrick@devforcelabs.com.br | 27 99241-5014
 * @group             :
 * @last modified on  : 12-27-2023
 * @last modified by  : patrick@devforcelabs.com.br | 27 99241-5014
 * Modifications Log
 * Ver   Date         Author                                        Modification
 * 1.0   12-23-2023   patrick@devforcelabs.com.br | 27 99241-5014   Initial Version
 **/ @isTest
public class AccountTriggerTest {
  // Usando TestSetup para preparar dados
  @TestSetup
  static void setup() {
  }

  // Teste para inserção de conta com CPF/CNPJ válido
  @isTest
  static void testValidAccountInsertion() {
    List<Account> validAccounts = new List<Account>{
      new Account(
        Name = 'Teste CPF Válido',
        AccountNumber = '12345678909',
        Type = 'CPF',
        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
          .get('Consumidor_Final')
          .getRecordTypeId()
      )
    };

    Test.startTest();
    insert validAccounts;
    Test.stopTest();

    System.assertEquals(
      validAccounts.size(),
      [SELECT COUNT() FROM Account WHERE Id IN :validAccounts]
    );
  }

  // Teste para inserção de conta com CPF/CNPJ inválido
  @isTest
  static void testInvalidAccountInsertion() {
    List<Account> invalidAccounts = new List<Account>{
      new Account(
        Name = 'Teste CPF Inválido',
        AccountNumber = 'DFE111111111',
        Type = 'CPF',
        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
          .get('Consumidor_Final')
          .getRecordTypeId()
      )
    };

    Boolean exceptionThrown = false;
    try {
      insert invalidAccounts;
    } catch (Exception e) {
      exceptionThrown = true;
    }
    System.assert(
      exceptionThrown,
      'Uma exceção deve ser lançada para contas inválidas'
    );
  }

  // Teste para inserções em lote
  @isTest
  static void testBatchAccountInsertion() {
    List<Account> batchAccounts = new List<Account>();
    for (Integer i = 0; i < 200; i++) {
      batchAccounts.add(
        new Account(
          Name = 'Batch Account ' + i,
          AccountNumber = '78945612309',
          Type = 'CPF',
          RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('Consumidor_Final')
            .getRecordTypeId()
        )
      );
    }

    Test.startTest();
    insert batchAccounts;
    Test.stopTest();

    System.assertEquals(
      batchAccounts.size(),
      [SELECT COUNT() FROM Account WHERE Id IN :batchAccounts]
    );
  }
}
