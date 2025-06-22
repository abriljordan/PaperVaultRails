import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "option", "radio"]
  static values = { 
    selectedColor: { type: String, default: "#4285f4" }
  }

  connect() {
    this.selectColor(this.selectedColorValue)
  }

  select(event) {
    const color = event.currentTarget.dataset.color
    this.selectColor(color)
  }

  selectColor(color) {
    this.selectedColorValue = color
    
    // Update radio buttons
    this.radioTargets.forEach(radio => {
      radio.checked = (radio.value === color)
    })
    
    // Update color preview
    if (this.hasPreviewTarget) {
      this.previewTarget.style.backgroundColor = color
    }
    
    // Update visual styling
    this.optionTargets.forEach(option => {
      const optionColor = option.dataset.color
      if (optionColor === color) {
        option.style.borderColor = '#3b82f6'
        option.style.borderWidth = '4px'
        option.style.transform = 'scale(1.15)'
        option.style.boxShadow = '0 4px 12px rgba(59, 130, 246, 0.3)'
      } else {
        option.style.borderColor = '#d1d5db'
        option.style.borderWidth = '3px'
        option.style.transform = 'scale(1)'
        option.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.1)'
      }
    })
  }
} 