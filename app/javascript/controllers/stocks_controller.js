import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="stocks"
export default class extends Controller {
	static values = {url: String, interval: Number}

	connect() {
		this.loadPrices()
		this.startAutoRefresh()
	}

	loadPrices = async () => {
		try {
			const response = await fetch(this.urlValue)
			const data = await response.json()

			data.forEach(stock => {
				const el = document.querySelector(`#stock-price-${stock.id}`)
				if (el) el.textContent = `$${stock.current_price.toFixed(2)}`
			})
		} catch (error) {
			console.error("Failed to load stock prices:", error)
		}
	}

	startAutoRefresh() {
		setInterval(() => this.loadPrices(), this.intervalValue || 10000)
	}
}
