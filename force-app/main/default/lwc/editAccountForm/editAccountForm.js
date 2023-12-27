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
import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class editAccountForm extends LightningElement {
  @api recordId;

  handleSuccess(event) {
    const evt = new ShowToastEvent({
      title: "Conta Atualizada",
      message: "Registro atualizado com sucesso: " + event.detail.id,
      variant: "success"
    });
    this.dispatchEvent(evt);

    // Resetar os campos do formulário
    this.resetFormFields();
  }

  resetFormFields() {
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        field.reset();
      });
    }
  }
}
