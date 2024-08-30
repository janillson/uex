import { Controller } from "@hotwired/stimulus"

// Exporta a classe do controlador
export default class extends Controller {
  static targets = ["map"]

  connect() {
    this.initMap()
  }

  initMap() {
    let timeoutId;
    const defaultLocations = [{ lat: -23.550520, lng: -46.633308, title: "São Paulo" }]

    this.map = new google.maps.Map(this.mapTarget, {
      center: { lat: -23.550520, lng: -46.633308 },
      zoom: 9
    })


    timeoutId = setTimeout(async () => {
      const url = this.data.get('url');
      const response = await fetch(url);

      if (!response.ok) {
        this.addMarkers(defaultLocations)
        return
      }

      const data = await response.json();

      if (data.length < 1) {
        this.addMarkers(defaultLocations)
        return
      }

      this.addMarkers(data)

    }, 500)
  }

  addMarkers(locations) {
    locations.forEach(location => {
      new google.maps.Marker({
        position: location,
        map: this.map,
        title: location.title
      })
    })
  }
}
