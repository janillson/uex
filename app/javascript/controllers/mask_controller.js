import { Controller } from "@hotwired/stimulus"
import IMask from 'imask'

export default class extends Controller {
  connect() {
    this.applyMasks()
  }

  applyMasks() {
    this.element.querySelectorAll('input[data-mask-type="cpf"]').forEach((element) => {
      this.mask = IMask(element, {
        mask: '000.000.000-00'
      })
    })

    this.element.querySelectorAll('input[data-mask-type="phone"]').forEach((element) => {
      this.mask = IMask(element, {
        mask: '(00) 00000-0000'
      })
    })

    this.element.querySelectorAll('input[data-mask-type="zipcode"]').forEach((element) => {
      this.mask = IMask(element, {
        mask: '00000-000'
      })
    })

    this.element.querySelectorAll('input[data-mask-type="uf"]').forEach((element) => {
      this.mask = IMask(element, {
        mask: 'AA',
        prepare: (value) => value.toUpperCase(),
        definitions: {
          'A': /[A-Z]/
        }
      })
    })
  }

  disconnect() {
    if (this.mask) this.mask.destroy()
  }
}
