import { Controller } from "@hotwired/stimulus"

// フラッシュ(トースト)を一定時間後にフェードアウトして消す。
export default class extends Controller {
  static values = { delay: { type: Number, default: 3500 } }

  connect() {
    this.hideTimer = setTimeout(() => {
      this.element.classList.add("flash--hide")
      this.removeTimer = setTimeout(() => this.element.remove(), 400)
    }, this.delayValue)
  }

  disconnect() {
    clearTimeout(this.hideTimer)
    clearTimeout(this.removeTimer)
  }
}
