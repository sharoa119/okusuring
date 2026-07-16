import { Controller } from "@hotwired/stimulus"

// 「再通知を有効にする」チェックが外れているときは、再通知までの時間を無効化する。
export default class extends Controller {
  static targets = ["enabled", "field", "interval"]

  connect() {
    this.toggle()
  }

  toggle() {
    const on = this.enabledTarget.checked
    this.intervalTarget.disabled = !on
    if (this.hasFieldTarget) {
      this.fieldTarget.classList.toggle("is-disabled", !on)
    }
  }
}
