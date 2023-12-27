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
@isTest
public with sharing class SetupGeralTest {
  @TestSetup
  static void setUp() {
    Pricebook2 tabPadrao = new Pricebook2();
    tabPadrao.Id = Test.getStandardPricebookId();
    tabPadrao.Name = 'Tabela Test';
    upsert tabPadrao;

    Product2 prd = new Product2();
    prd.Name = 'Produto 1';
    prd.ProductCode = '00001';
    prd.IsActive = true;
    insert prd;

    List<PricebookEntry> prices = [
      SELECT Id, Product2Id
      FROM PricebookEntry
      WHERE
        Product2Id = :prd.Id
        AND isActive = TRUE
        AND Pricebook2.IsStandard = TRUE
    ];

    System.debug(prices);

    Test.startTest();

    Id rtContaConsumidor = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Consumidor_Final')
      .getRecordTypeId();
    Id rtContaParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Parceiro')
      .getRecordTypeId();

    Account acc = new Account();
    acc.RecordTypeId = rtContaConsumidor;
    acc.Name = 'DevForce Labs';
    acc.NomCta__c = 'DevForce Labs LTDA';
    acc.AccountNumber = '53105583000181';
    acc.Type = 'CNPJ';
    acc.CgcCpf__c = '53105583000181';
    acc.TipPes__c = 'J';
    acc.Phone = '27 99890-3047';
    acc.BillingStreet = 'RUA PRESIDENTE RODRIGUES ALVES, 12';
    acc.BillingCity = 'Vitória';
    acc.BillingStateCode = 'ES';
    acc.BillingCountryCode = 'BR';
    acc.BillingPostalCode = '29070145';
    insert acc;

    acc.RecordTypeId = rtContaParceiro;
    acc.Type = 'CPF';
    acc.AccountNumber = '12233554701';
    update acc;

    Contact contato = new Contact();
    contato.FirstName = 'Patrick';
    contato.LastName = 'Ribeiro';
    contato.Email = 'patrick@devforcelabs.com.br';
    contato.MobilePhone = '27 99241-5014';
    contato.AccountId = acc.Id;
    contato.Title = 'CEO';
    insert contato;

    // Conta_Bancaria__c contBan = new Conta_Bancaria__c();
    //     contBan.Tipo__c = 'Conta Corrente';
    //     contBan.Banco__c = 'BS2';
    //     contBan.Token__c = 'ad9-1dij1m-548';
    // insert contBan;

    // Plano_Financeiro__c plan = new Plano_Financeiro__c();
    //     plan.Grupo_de_Contas__c = '02 - IMPOSTOS S/ RECEITAS';
    //     plan.Name = '173-Nome Conta';
    //     plan.Nome_Conta__c = 'Nome Conta';
    // insert plan;

    Opportunity opp = new Opportunity();
    opp.AccountId = acc.Id;
    opp.StageName = 'Qualification';
    opp.Name = acc.Name + ' - opp';
    // opp.currencyisocode = 'BRL';
    opp.CloseDate = System.today().addDays(30);
    opp.ContactId = contato.id;
    insert opp;

    // Contract contrato = new Contract();
    //     contrato.AccountId = acc.Id;
    //     contrato.Status = 'Draft';
    //     contrato.Name = 'a';
    //     contrato.StartDate = System.today();
    //     contrato.ContractTerm = 5;
    //     contrato.Receita_Recorrente__c = 'Sim';
    //     contrato.Oportunidade__c = opp.Id;
    //     contrato.CurrencyIsoCode = 'BRL';
    //     contrato.Tipo_Reajuste__c = 'IPCA';
    // insert contrato;

    // Financeiro__c fin = new Financeiro__c();
    //     fin.CodCcu__c = 'Tableau';
    //     fin.IdeCco__c = contBan.Id;
    //     fin.VlrOri__c = 0;
    //     fin.datemi__c = System.today();
    //     fin.DatCom__c = System.today();
    //     fin.DatVct__c = System.today().addDays(30);
    //     fin.VlrOri__c = 2;
    //     fin.IdePla__c = plan.id;
    //     fin.IdeCta__c = acc.Id;
    //     fin.Contrato__c = contrato.Id;
    //     fin.ObsTit__c = 'a';
    //     fin.BolBs2__c = 'ba20454e-c6e4-4e4f-94f9-fffa54c1a34c';
    //     fin.IdCancelamento__c = '1bac70f7-a75d-4eb7-a58e-75db79192be9';
    //     fin.IdNovoVenc__c = '1bac70f7-a75d-4eb7-a58e-75db79192be9';
    // insert fin;
    Test.stopTest();
  }
}
