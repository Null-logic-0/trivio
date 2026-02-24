import {Controller} from "@hotwired/stimulus"

Chartkick.use(Chart)

export default class extends Controller {
	static targets = ["chart"]
	static values = {url: String, interval: Number}

	connect() {
		setTimeout(() => {
			if (!this.hasChartTarget) return console.error("Missing chart target")
			this.chart = Chartkick.charts[this.chartTarget.id]
			if (this.intervalValue) this.startPolling()
		})

	}

	startPolling() {
		this.poll = setInterval(() => this.refreshChart(), this.intervalValue)
	}

	async refreshChart() {
		try {
			const res = await fetch(this.urlValue, {headers: {Accept: "application/json"}})
			const data = await res.json()
			if (this.chart) this.chart.updateData(data)
		} catch (e) {
			console.error("Chart update failed:", e)
		}
	}

	disconnect() {
		if (this.poll) clearInterval(this.poll)
	}
}