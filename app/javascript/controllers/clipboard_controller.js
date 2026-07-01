import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "message"]

  async copy() {
    try {
      await navigator.clipboard.writeText(this.sourceTarget.value)

      this.messageTarget.textContent = "リンクをコピーしました"
      this.messageTarget.hidden = false

      setTimeout(() => {
        this.messageTarget.hidden = true
      }, 2000)
    } catch (error) {
      this.messageTarget.textContent = "コピーできませんでした。URLを長押ししてコピーしてください。"

      this.messageTarget.hidden = false

      setTimeout(() => {
        this.messageTarget.hidden = true
      }, 2000)
    }
  }
}
