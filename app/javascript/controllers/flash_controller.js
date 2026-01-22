import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    autoDismiss: { type: Boolean, default: true },
    delay: { type: Number, default: 5000 }
  }

  connect() {
    if (this.autoDismissValue) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, this.delayValue)
    }
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-x-4")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}