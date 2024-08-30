import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['zipcodeValue', 'streetValue', 'neighborhoodValue', 'cityValue', 'stateValue']

  connect() {
    let zipcode = this.zipcodeValueTarget
    let timeoutId;

    zipcode.addEventListener('input', () => {
      clearTimeout(timeoutId);

      const query = zipcode.value;

      if (query.length <= 7) return

      timeoutId = setTimeout(async () => {
        const url = this.data.get('url');
        const response = await fetch(`${url}?term=${query}`);

        if (!response.ok) return

        const data = await response.json();

        if (Object.keys(data).length < 1) return

        let street = this.streetValueTarget
        street.value = data.street

        let neighborhood = this.neighborhoodValueTarget
        neighborhood.value = data.neighborhood

        let city_name = this.cityValueTarget
        city_name.value = data.city_name

        let state = this.stateValueTarget
        state.value = data.state

      }, 500)
    })
  }
}