import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sleep", "wake", "value"]

  updateValue() {
    const sleepTime = this.sleepTarget.value
    const wakeTime = this.wakeTarget.value

    if (sleepTime && wakeTime) {
      this.valueTarget.value = `${sleepTime}-${wakeTime}`
    } else {
      this.valueTarget.value = ""
    }
  }
}
