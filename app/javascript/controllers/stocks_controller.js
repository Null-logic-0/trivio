import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="stocks"
export default class extends Controller {
	static values = {url: String, interval: Number}

	connect() {
		this.loadTable()
		this.startAutoRefresh()
	}

	loadTable = async () => {
		try {
			const response = await fetch(this.urlValue)
			const data = await response.json()

			// Remove skeleton if exists
			const skeleton = document.getElementById("stocks-skeleton")
			if (skeleton) skeleton.remove()

			// Fill prices safely
			data.forEach(stock => {
				const el = document.querySelector(`#stock-price-${stock.id}`)
				if (el) {
					const price = Number(stock.current_price)
					el.textContent = isNaN(price) ? "N/A" : `$${price.toFixed(2)}`
				}
			})
		} catch (error) {
			console.error("Failed to load table or prices:", error)
		}
	}

	startAutoRefresh() {
		setInterval(() => this.loadPrices(), this.intervalValue || 10000)
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

	disconnect() {
		clearInterval(this.timer)
	}


}
