import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    itemId: Number,
    url: String
  }

  async toggle(event) {
    event.preventDefault()

    const label = event.currentTarget
    const isVisible = !label.classList.contains("on")

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        }
      })

      if (response.ok) {
        // トグルの見た目を切り替え
        label.classList.toggle("on")
      } else {
        console.error("Toggle failed:", response.statusText)
      }
    } catch (error) {
      console.error("Toggle error:", error)
    }
  }
}