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

public with sharing class AccountTriggerHandler {
  public static void handleBeforeInsert(List<Account> newAccounts) {
    System.debug(
      'handleBeforeInsert: Iniciando processamento de ' +
        newAccounts.size() +
        ' contas.'
    );
    validarContas(newAccounts);
  }
  public static void handleAfterInsert(List<Account> newAccounts) {
    System.debug(
      'handleAfterInsert: Iniciando processamento de ' +
        newAccounts.size() +
        ' contas.'
    );
    criarOportunidadeParceiro(newAccounts);
    criarTarefaConsumidor(newAccounts);
  }

  private static void validarContas(List<Account> contas) {
    for (Account acc : contas) {
      if (acc.Type == 'CPF' && !Utils.validaCPF(acc.AccountNumber)) {
        acc.AccountNumber.addError('CPF do cliente é invalido');
      } else if (acc.Type == 'CNPJ' && !Utils.validaCNPJ(acc.AccountNumber)) {
        acc.AccountNumber.addError('CNPJ do parceiro é invalido');
      }
    }
  }

  private static void criarOportunidadeParceiro(List<Account> contas) {
    System.debug(
      'criarOportunidadeParceiro: Iniciando criação de oportunidades.'
    );
    List<Opportunity> oppsInsert = new List<Opportunity>();
    Id parceiroRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Parceiro')
      .getRecordTypeId();

    for (Account acc : contas) {
      if (acc.RecordTypeId == parceiroRecordTypeId) {
        System.debug('Criando Oportunidade para Parceiro: ' + acc.Name);
        Opportunity opp = new Opportunity(
          Name = acc.Name + ' – opp Parceiro',
          CloseDate = System.today().addDays(30),
          StageName = 'Qualification',
          AccountId = acc.Id
        );
        oppsInsert.add(opp);
      }
    }

    if (
      !oppsInsert.isEmpty() && Schema.sObjectType.Opportunity.isCreateable()
    ) {
      System.debug('Criando Oportunidade para Parceiro: ');
      insert oppsInsert;
    } else {
      System.debug('Nenhuma oportunidade a ser inserida.');
    }
  }

  private static void criarTarefaConsumidor(List<Account> contas) {
    List<Task> taskInsert = new List<Task>();
    Id consumidorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Consumidor Final')
      .getRecordTypeId();

    for (Account acc : contas) {
      if (acc.RecordTypeId == consumidorRecordTypeId) {
        System.debug('Criando tarefa para Consumidor Final: ' + acc.Name);
        Task tk = new Task(
          Subject = 'Consumidor Final',
          WhatId = acc.Id,
          Status = (UserInfo.getLocale() == 'pt_BR'
            ? 'Não Iniciada'
            : 'Not Started'),
          Priority = 'Normal'
        );

        taskInsert.add(tk);
      }
    }
    if (!taskInsert.isEmpty() && Schema.sObjectType.Task.isCreateable()) {
      System.debug('Criando tarefa para Consumidor: ');
      insert taskInsert;
    } else {
      System.debug('Nenhuma tarefa foi criada.');
    }
  }
}
