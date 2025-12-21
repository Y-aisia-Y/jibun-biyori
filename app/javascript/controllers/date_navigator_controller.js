import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date"]

  connect() {
    this.currentDate = new Date()
    this.render()
  }

  prev() {
    this.currentDate.setDate(this.currentDate.getDate() - 1)
    this.render()
  }

  next() {
    this.currentDate.setDate(this.currentDate.getDate() + 1)
    this.render()
  }

  render() {
    // 日本語曜日の配列
    const weekdays = ["日", "月", "火", "水", "木", "金", "土"]
    
    const y = this.currentDate.getFullYear()
    const m = this.currentDate.getMonth() + 1
    const d = this.currentDate.getDate()
    const w = weekdays[this.currentDate.getDay()]

    this.dateTarget.textContent = `${y}年${m}月${d}日(${w})`
  }
}
