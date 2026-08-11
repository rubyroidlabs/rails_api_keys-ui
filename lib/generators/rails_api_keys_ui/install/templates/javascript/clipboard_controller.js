import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "feedback"]

  async copy() {
    const value = this.sourceTarget.value
    try {
      await navigator.clipboard.writeText(value)
    } catch (_error) {
      this.sourceTarget.select()
      document.execCommand("copy")
    }

    if (this.hasFeedbackTarget) {
      this.feedbackTarget.classList.remove("hidden")
    }
  }
}
