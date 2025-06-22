import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Dropdown controller connected")
    // Ensure menu starts hidden
    this.hideMenu()
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    console.log("Dropdown controller disconnected")
    document.removeEventListener('click', this.handleClickOutside)
  }

  toggle(event) {
    console.log("Dropdown toggle called")
    event.preventDefault()
    event.stopPropagation()
    
    if (this.menuTarget.classList.contains('hidden')) {
      this.showMenu()
    } else {
      this.hideMenu()
    }
    
    // Close other dropdowns
    this.closeOtherDropdowns()
  }

  showMenu() {
    this.menuTarget.classList.remove('hidden')
    console.log("Menu shown")
  }

  hideMenu() {
    this.menuTarget.classList.add('hidden')
    console.log("Menu hidden")
  }

  closeOtherDropdowns() {
    // Close all other dropdown menus
    document.querySelectorAll('[data-dropdown-target="menu"]').forEach(menu => {
      if (menu !== this.menuTarget) {
        menu.classList.add('hidden')
      }
    })
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideMenu()
    }
  }
}