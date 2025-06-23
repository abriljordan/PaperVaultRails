import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.avatarElement = this.element.querySelector('.avatar-clickable')
    this.fileInput = this.element.querySelector('input[type="file"]')
    
    if (this.avatarElement && this.fileInput) {
      this.avatarElement.addEventListener('click', () => {
        this.fileInput.click()
      })
    }
  }

  updateAvatar(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const avatar = this.avatarElement.querySelector('img')
        if (avatar) {
          avatar.src = e.target.result
        }
      }
      reader.readAsDataURL(file)
    }
  }
}
