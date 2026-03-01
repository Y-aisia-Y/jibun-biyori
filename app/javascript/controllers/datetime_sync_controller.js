import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "startHour", "startMinute", "endDate", "endHour", "endMinute"]

  updateEndTime() {
    const date = this.startDateTarget.value
    const hour = parseInt(this.startHourTarget.value)
    const minute = parseInt(this.startMinuteTarget.value)

    if (!date) return

    const startDate = new Date(`${date}T${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}`)
    const endDate = new Date(startDate.getTime() + 60 * 60 * 1000)

    this.endDateTarget.value = `${endDate.getFullYear()}-${String(endDate.getMonth() + 1).padStart(2, '0')}-${String(endDate.getDate()).padStart(2, '0')}`
    this.endHourTarget.value = String(endDate.getHours())
    this.endMinuteTarget.value = String(Math.round(endDate.getMinutes() / 5) * 5)
  }
}
