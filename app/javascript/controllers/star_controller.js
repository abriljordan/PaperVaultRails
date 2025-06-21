import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "unstar"]

  connect() {
    console.log("Star controller connected")
  }

  star(event) {
    event.preventDefault()
    const link = event.currentTarget
    const url = link.href

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.starred) {
        this.showSuccessMessage(data.message)
        this.updateStarState(true)
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.showErrorMessage('Failed to star item')
    })
  }

  unstar(event) {
    event.preventDefault()
    const link = event.currentTarget
    const url = link.href

    fetch(url, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (!data.starred) {
        this.showSuccessMessage(data.message)
        this.updateStarState(false)
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.showErrorMessage('Failed to unstar item')
    })
  }

  updateStarState(starred) {
    if (starred) {
      this.starTarget.classList.add('hidden')
      this.unstarTarget.classList.remove('hidden')
    } else {
      this.starTarget.classList.remove('hidden')
      this.unstarTarget.classList.add('hidden')
    }
  }

  showSuccessMessage(message) {
    // Create a temporary success message
    const messageDiv = document.createElement('div')
    messageDiv.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg z-50'
    messageDiv.textContent = message
    document.body.appendChild(messageDiv)

    // Remove after 3 seconds
    setTimeout(() => {
      messageDiv.remove()
    }, 3000)
  }

  showErrorMessage(message) {
    // Create a temporary error message
    const messageDiv = document.createElement('div')
    messageDiv.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded shadow-lg z-50'
    messageDiv.textContent = message
    document.body.appendChild(messageDiv)

    // Remove after 3 seconds
    setTimeout(() => {
      messageDiv.remove()
    }, 3000)
  }
} 