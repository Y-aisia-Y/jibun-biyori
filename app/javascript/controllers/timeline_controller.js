import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    currentHour: Number,
    currentMinute: Number
  }

  connect() {
    console.log("Timeline controller connected!")
    console.log(`サーバー時刻: ${this.currentHourValue}:${this.currentMinuteValue}`)
    
    // 接続後に位置を設定
    this.positionNowLine()
    this.scrollToCurrentTime()
  }

  positionNowLine() {
    const hours = this.currentHourValue
    const minutes = this.currentMinuteValue
    
    console.log(`使用する時刻: ${hours}:${minutes}`)
    
    const HOUR_HEIGHT = 80 // 1時間ブロックの高さ（px）
    const topPosition = (hours * HOUR_HEIGHT) + (minutes / 60) * HOUR_HEIGHT
    
    console.log(`計算されたtop: ${topPosition}px`)
    
    // ⭐ 修正: querySelectorで要素を取得
    const nowLine = this.element.querySelector('.now-line')
    
    if (nowLine) {
      nowLine.style.top = `${topPosition}px`
      console.log(`赤いラインを設定: ${topPosition}px`)
      console.log('nowLineの要素:', nowLine) // デバッグ用
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