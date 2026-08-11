import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop", "panel"]
  static values = { openOnConnect: Boolean }

  connect() {
    if (this.openOnConnectValue) {
      this.open()
      return
    }

    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
    }
  }

  open() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove("hidden")
      document.body.classList.add("overflow-hidden")
    }
  }

  close() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }
  }

  closeOnBackdropClick(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
