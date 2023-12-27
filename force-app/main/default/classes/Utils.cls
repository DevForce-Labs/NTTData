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

public class Utils {
  public static Boolean validaCPF(String cpf) {
    return cpf != null && cpf.length() == 11;
  }

  public static Boolean validaCNPJ(String cnpj) {
    return cnpj != null && cnpj.length() == 14;
  }
}
