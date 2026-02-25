class ApplicationController < ActionController::Base
	include Authentication
	include Pagy::Method

	# Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
	allow_browser versions: :modern

	# Changes to the importmap will invalidate the etag for HTML responses
	stale_when_importmap_changes
	before_action :load_top_movers

	private

	def load_top_movers
		@top_movers = StockDataService.new(nil).top_movers
	end
end
