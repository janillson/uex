import { Controller } from "@hotwired/stimulus"
import { Modal } from 'bootstrap'

export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element)
    this.showModal()
  }

  showModal() {
    this.modal.show();
  }
}
