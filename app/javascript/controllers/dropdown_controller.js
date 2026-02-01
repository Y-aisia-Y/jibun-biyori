import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle() {
    this.panelTarget.classList.toggle("hidden")
  }

  // メニュー外をクリックしたら閉じる
  close(event) {
    if (!this.element.contains(event.target)) {
      this.panelTarget.classList.add("hidden")
    }
  }

  connect() {
    // ページ読み込み時にイベントリスナーを追加
    document.addEventListener("click", this.close.bind(this))
  }

  disconnect() {
    // コントローラーが削除されるときにイベントリスナーを解除
    document.removeEventListener("click", this.close.bind(this))
  }
}