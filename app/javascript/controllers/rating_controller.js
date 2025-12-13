import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "text"]

  connect() {
    this.updateUI()
  }

  select(event) {
    this.updateUI(event.target.value)
  }

  updateUI(selectedValue = null) {
    const currentRating =
      selectedValue ||
      this.element.querySelector('input[type="radio"]:checked')?.value

    this.labelTargets.forEach(label => {
      const input = document.getElementById(label.getAttribute('for'))
      const textTarget = label.nextElementSibling
      const isSelected = input.value === currentRating

      label.classList.toggle('bg-white', isSelected)
      label.classList.toggle('shadow-xl', isSelected)
      label.classList.toggle('ring-4', isSelected)
      label.classList.toggle('ring-indigo-400', isSelected)
      label.classList.toggle('bg-gray-100', !isSelected)
      label.classList.toggle('hover:bg-indigo-200', !isSelected)

      textTarget.classList.toggle('text-indigo-600', isSelected)
      textTarget.classList.toggle('font-bold', isSelected)
      textTarget.classList.toggle('text-gray-600', !isSelected)
    })
  }
}
