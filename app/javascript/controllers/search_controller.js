import { Controller } from "@hotwired/stimulus"
import autoComplete from "@tarekraafat/autocomplete.js"

export default class extends Controller {
  static targets = ['zipcodeValue', 'streetValue', 'neighborhoodValue', 'cityValue', 'stateValue']

  connect() {
    this.autoCompleteInstances = {}
    this.autocompleteConfig()
  }

  async autocompleteContact(event) {
    const autoCompleteJS = this.autoCompleteInstances[event.target.id]

    if (!autoCompleteJS) return

    let results = await this.getResults(event.target.dataset.url, event.target.value, 1)

    if (!results) return

    results.map(result => { result.format_type = 'contact' })
    autoCompleteJS.data.keys = ['name', 'cpf', 'format_type']
    autoCompleteJS.data.src =  results
    autoCompleteJS.start()
  }

  async autocompleteAdrress(event) {
    const autoCompleteJS = this.autoCompleteInstances[event.target.id]

    if (!autoCompleteJS) return

    let results = await this.getResults(event.target.dataset.url, event.target.value, 2)

    if (!results) return

    if (Object.keys(results).length < 1) return

    results.map(result => { result.format_type = 'address' })
    autoCompleteJS.data.keys = ['street', 'number', 'complement', 'neighborhood', 'city_name', 'state', 'zipcode', 'format_type']
    autoCompleteJS.data.src = results
    autoCompleteJS.start()
  }

  async getResults(url, query, min_query) {
    if (!url && !query) return []

    if (query.length <= min_query) return

    const response = await fetch(`${url}?term=${query}`)

    if (response.ok) this.response = await response.json()

    return this.parseResponse(this.response)
  }

  parseResponse(response) {
    if (!response || Object.keys(response).length === 0 || response.length === 0) return []

    if (Array.isArray(response)) return response

    return [response]
  }

  setAddresses(address) {
    let zipcode = this.zipcodeValueTarget
    zipcode.value = address.zipcode

    let street = this.streetValueTarget
    street.value = address.street

    let neighborhood = this.neighborhoodValueTarget
    neighborhood.value = address.neighborhood

    let city_name = this.cityValueTarget
    city_name.value = address.city_name

    let state = this.stateValueTarget
    state.value = address.state
  }

  sendForm(event) {
    event.preventDefault()
    event.target.submit()
  }


  labelFormatter(data) {
    let type = data.value.format_type
    let value = data.value
    let label
    const addressParts = [
      value.street && value.street,
      value.number && value.number,
      value.neighborhood && value.neighborhood,
      value.city_name && value.city_name,
      value.state && value.state,
      value.zipcode && value.zipcode
    ]

    switch (type) {
      case 'address':
        label = data.match
        label += '<br>'
        label += addressParts.filter(Boolean).join(', ').replace(/, -/g, ' -')
        break
      case 'contact':
        label = data.match
        label += '<br>'
        label += `${value.name} - ${value.cpf}`
        label += '<br>'
        label += `<small>${addressParts.filter(Boolean).join(', ').replace(/, -/g, ' -')}</small>`
        break
      default:
        label = data.match
    }

    return label
  }

  autocompleteConfig() {
    const inputs = this.element.querySelectorAll('.autocomplete')

    inputs.forEach(element => {
      this.autoCompleteInstances[element.id] = new autoComplete({
        selector: () => element,
        data: {
            src: [],
            cache: false,
        },
        resultItem: {
            highlight: true,
            element: (item, data) => {
              item.classList.add("list-group-item", "list-group-item-action")
              item.style.cursor = "pointer"
              item.innerHTML = this.labelFormatter(data)
            },
        },
        resultsList: {
          element: (list) => {
            list.classList.add("autoCompleteList")
            list.classList.add("list-group")
          },
          noResults: true,
        },
        events: {
          input: {
            selection: (event) => {
              let values = event.detail.selection.value
              let key = event.detail.selection.key
              let value = values[key]

              element.value = value

              if (!values.hasOwnProperty('format_type')) return

              switch (values.format_type) {
                case 'address':
                  this.setAddresses(values)
                  break
                case 'contact':
                  event.target.form.submit()
                  break
              }
            }
          }
        },
      })
    })
  }
}
