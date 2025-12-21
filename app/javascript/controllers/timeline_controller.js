import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.update()
  }

  update() {
    const now = new Date()
    const minutes = now.getHours() * 60 + now.getMinutes()
    const ratio = minutes / 1440

    const timelineHeight = this.element.offsetHeight
    const top = timelineHeight * ratio

    const line = this.element.querySelector(".now-line")
    if (line) {
      line.style.top = `${top}px`
    }
  }
}
