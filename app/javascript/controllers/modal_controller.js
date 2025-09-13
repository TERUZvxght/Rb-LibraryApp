import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel"]
  static values = { id: String } // 複数モーダル用の識別子

  connect() {
    // window経由のイベントを受け取る
    this.openHandler  = (e) => { if (!e.detail?.id || e.detail.id === this.idValue) this.open() }
    this.closeHandler = (e) => { if (!e.detail?.id || e.detail.id === this.idValue) this.close() }
    window.addEventListener("modal:open", this.openHandler)
    window.addEventListener("modal:close", this.closeHandler)
  }

  disconnect() {
    window.removeEventListener("modal:open", this.openHandler)
    window.removeEventListener("modal:close", this.closeHandler)
  }

  open()  { this.backdropTarget.classList.remove("hidden"); this.backdropTarget.setAttribute("aria-hidden", "false") }
  close() { this.backdropTarget.classList.add("hidden");    this.backdropTarget.setAttribute("aria-hidden", "true") }
}