import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["zone", "input", "info", "name", "size", "nameField"]

  connect() {
    this.setupDragAndDrop()
    this.setupFileInput()
  }

  setupDragAndDrop() {
    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      this.zoneTarget.addEventListener(eventName, this.preventDefaults.bind(this), false)
      document.body.addEventListener(eventName, this.preventDefaults.bind(this), false)
    })

    // Highlight drop zone when item is dragged over it
    ['dragenter', 'dragover'].forEach(eventName => {
      this.zoneTarget.addEventListener(eventName, this.highlight.bind(this), false)
    })

    ['dragleave', 'drop'].forEach(eventName => {
      this.zoneTarget.addEventListener(eventName, this.unhighlight.bind(this), false)
    })

    // Handle dropped files
    this.zoneTarget.addEventListener('drop', this.handleDrop.bind(this), false)
  }

  setupFileInput() {
    this.inputTarget.addEventListener('change', (e) => {
      const file = e.target.files[0]
      if (file) {
        this.showFileInfo(file)
      }
    })
  }

  preventDefaults(e) {
    e.preventDefault()
    e.stopPropagation()
  }

  highlight(e) {
    this.zoneTarget.classList.add('border-blue-400', 'bg-blue-50')
  }

  unhighlight(e) {
    this.zoneTarget.classList.remove('border-blue-400', 'bg-blue-50')
  }

  handleDrop(e) {
    const dt = e.dataTransfer
    const files = dt.files
    
    if (files.length > 0) {
      this.inputTarget.files = files
      this.showFileInfo(files[0])
    }
  }

  showFileInfo(file) {
    console.log('Showing file info for:', file.name)
    this.nameTarget.textContent = file.name
    this.sizeTarget.textContent = this.formatFileSize(file.size)
    this.infoTarget.classList.remove('hidden')
    
    // Also update the file name field if it's empty
    if (this.hasNameFieldTarget && this.nameFieldTarget.value === '') {
      this.nameFieldTarget.value = file.name
    }
  }

  formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }
} 