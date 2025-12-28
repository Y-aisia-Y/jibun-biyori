import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { recordId: Number }

  select(event) {
    const rating = event.currentTarget.dataset.ratingValue
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/records/${this.recordIdValue}/mood`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": csrfToken
      },
      body: `mood[rating]=${rating}`
    })
    .then(response => {
      if (response.ok) {
        this.element.querySelectorAll("label").forEach((el, index) => {
          el.classList.toggle("text-yellow-400", index < rating)
          el.classList.toggle("text-gray-300", index >= rating)
        })
      }
    })
    .catch(error => {
      console.error("Error:", error)
    })
  }
}
