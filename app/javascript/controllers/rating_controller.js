import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static values = { recordId: Number }

  select(event) {
    const rating = event.currentTarget.dataset.ratingValue

    Rails.ajax({
      url: `/records/${this.recordIdValue}/mood`,
      type: "PATCH",
      data: `mood[rating]=${rating}`,
      success: () => {
        this.element.querySelectorAll("label").forEach((el, index) => {
          el.classList.toggle("text-yellow-400", index < rating)
          el.classList.toggle("text-gray-300", index >= rating)
        })
      }
    })
  }
}
