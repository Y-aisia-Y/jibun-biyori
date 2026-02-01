import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sleepHour", "sleepMinute", "wakeHour", "wakeMinute", "value"]

  updateValue() {
    const sh = this.sleepHourTarget.value
    const sm = this.sleepMinuteTarget.value
    const wh = this.wakeHourTarget.value
    const wm = this.wakeMinuteTarget.value

    if (sh && sm && wh && wm) {
      this.valueTarget.value = `${sh}:${sm}-${wh}:${wm}`
    }
  }
}
