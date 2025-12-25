import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="datetime-sync"
export default class extends Controller {
  static targets = ["startTime", "endTime"]

  // 開始時刻
  updateEndTime() {
    const startTimeValue = this.startTimeTarget.value
    
    if (!startTimeValue) {
      return
    }

    const startDate = new Date(startTimeValue)
    
    // 1時間後の時刻
    const endDate = new Date(startDate.getTime() + 60 * 60 * 1000)
    
    const year = endDate.getFullYear()
    const month = String(endDate.getMonth() + 1).padStart(2, '0')
    const day = String(endDate.getDate()).padStart(2, '0')
    const hours = String(endDate.getHours()).padStart(2, '0')
    const minutes = String(endDate.getMinutes()).padStart(2, '0')
    
    const formattedEndTime = `${year}-${month}-${day}T${hours}:${minutes}`
    
    // 終了時刻
    this.endTimeTarget.value = formattedEndTime
  }
}
