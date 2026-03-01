import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle(event) {
    event.stopPropagation()
    this.panelTarget.classList.toggle("hidden")

    if (this.panelTarget.classList.contains("hidden")) {
      this.closeAllAccordions()
    }
  }

  hide() {
    this.panelTarget.classList.add("hidden")
    this.closeAllAccordions()
  }

  closeAllAccordions() {
    const accordions = this.panelTarget.querySelectorAll("details")
    accordions.forEach((accordion) => {
      accordion.removeAttribute("open")
    })
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.panelTarget.classList.add("hidden")
      this.closeAllAccordions()
    }
  }

  connect() {
    this.clickOutsideHandler = this.close.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }
}