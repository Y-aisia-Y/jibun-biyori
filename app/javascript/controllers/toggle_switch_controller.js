import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "submitButton"]
  static values = {
    url: String
  }

  connect() {
    console.log("Toggle switch controller connected!")
    console.log("URL:", this.urlValue)
  }

  async toggle(event) {
    event.preventDefault()
    console.log("Toggle clicked!")

    const label = this.labelTarget
    const isVisible = label.classList.contains("on")

    console.log("Current state:", isVisible ? "visible" : "hidden")

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        },
        credentials: "same-origin"
      })

      if (response.ok) {
        console.log("Toggle success!")
        // トグルの見た目を切り替え
        if (isVisible) {
          label.classList.remove("on")
          console.log("Changed to: hidden")
        } else {
          label.classList.add("on")
          console.log("Changed to: visible")
        }
      } else {
        console.error("Toggle failed:", response.statusText)
      }
    } catch (error) {
      console.error("Toggle error:", error)
    }
  }
}