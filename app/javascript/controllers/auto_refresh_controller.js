import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="auto-refresh"
export default class extends Controller {
	connect() {
		this.start()
	}

	start() {
		this.interval = setInterval(() => {
			this.element.reload()
		}, 3000)
	}

	disconnect() {
		clearInterval(this.interval)
	}
}
