import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    currentHour: Number,
    currentMinute: Number
  }

  connect() {
    this.positionNowLine()
    this.scrollToCurrentTime()
  }

  positionNowLine() {
    const nowLine = this.element.querySelector('.now-line')
    
    // .now-line が存在しない場合は何もしない(エラーログも出さない)
    if (!nowLine) {
      return
    }

    const hours = this.currentHourValue
    const minutes = this.currentMinuteValue
    const HOUR_HEIGHT = 80
    const topPosition = (hours * HOUR_HEIGHT) + (minutes / 60) * HOUR_HEIGHT
    
    nowLine.style.top = `${topPosition}px`
  }

  scrollToCurrentTime() {
    const hours = this.currentHourValue
    const minutes = this.currentMinuteValue
    const HOUR_HEIGHT = 80
    const scrollPosition = (hours * HOUR_HEIGHT) + (minutes / 60) * HOUR_HEIGHT
    const containerHeight = this.element.clientHeight
    const offsetPosition = Math.max(0, scrollPosition - (containerHeight / 2))
    
    this.element.scrollTo({
      top: offsetPosition,
      behavior: 'smooth'
    })
  }
}