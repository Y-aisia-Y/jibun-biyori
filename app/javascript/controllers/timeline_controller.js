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
    const hours = this.currentHourValue
    const minutes = this.currentMinuteValue
    const HOUR_HEIGHT = 80
    const topPosition = (hours * HOUR_HEIGHT) + (minutes / 60) * HOUR_HEIGHT
  
    const nowLine = this.element.querySelector('.now-line')
    
    if (nowLine) {
      nowLine.style.top = `${topPosition}px`
    } else {
      console.error('.now-line 要素が見つかりません')
    }
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
