import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const toggleSwitch = event.currentTarget
    const itemId = toggleSwitch.dataset.itemId
    const url = toggleSwitch.dataset.url

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
    .then(response => {
      if (response.ok) {
        toggleSwitch.classList.toggle('on')
      } else {
        console.error('Failed to update visibility')
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
}