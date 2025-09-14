import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ["panel", "input", "toggle"]
  static targets = ["hitbox", "icon", "background", "input"]

  connect() {
    // this._onDocClick = this._onDocClick.bind(this)
    // this._onKeydown = this._onKeydown.bind(this)
  }

  focus() { this.inputTarget.focus(); }

  open() {
    this.inputTarget.classList.remove("scale-x-0");
    this.inputTarget.classList.add("scale-x-100", "delay-100");
    this.hitboxTarget.classList.remove("hover:opacity-100");
    this.hitboxTarget.classList.add("select-none");
    this.backgroundTarget.classList.add("bg-white", "opacity-100");
    this.iconTarget.classList.remove("translate-x-43.5");
    this.iconTarget.classList.add("translate-x-0");
    this.inputTarget.focus();
  }

  checkClose() {
    if (!this.inputTarget.value) this.close();
  }
  close() {
    this.inputTarget.classList.remove("scale-x-100", "delay-100");
    this.inputTarget.classList.add("scale-x-0");
    this.hitboxTarget.classList.remove("select-none");
    this.hitboxTarget.classList.add("hover:opacity-100");
    this.backgroundTarget.classList.remove("bg-white", "opacity-100");
    this.iconTarget.classList.add("translate-x-43.5");
    this.iconTarget.classList.remove("translate-x-0");
    this.inputTarget.value = "";
    this.inputTarget.blur();
  }

  // close() {
  //   this.panelTarget.classList.add("scale-x-0","opacity-0","pointer-events-none")
  //   this.panelTarget.classList.remove("scale-x-100","opacity-100")
  //   this.toggleTarget.setAttribute("aria-expanded", "false")
  //   document.removeEventListener("mousedown", this._onDocClick)
  //   document.removeEventListener("keydown", this._onKeydown)
  // }

  // _onDocClick(e) {
  //   if (!this.element.contains(e.target) && !this.inputTarget.value) this.close()
  // }

  // _onKeydown(e) {
  //   alert(e.key)
  //   if (e.key === "f") this.open()
  //   if (e.key === "Escape") this.close()
  // }
}