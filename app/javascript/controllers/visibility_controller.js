import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radio"]

  toggle(event) {
    const itemId = event.currentTarget.dataset.itemId
    const url = event.currentTarget.dataset.url

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
  }
}
