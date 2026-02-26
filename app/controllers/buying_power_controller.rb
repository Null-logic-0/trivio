class BuyingPowerController < ApplicationController

	def reset
		Current.user.update!(buying_power: 10_000)
		Current.user.reload

		flash.now[:notice] = "Buying Power Updated!"
		respond_to do |format|
			format.turbo_stream do
				render turbo_stream: [
					turbo_stream.replace("buying_power", partial: "shared/buying_power"),
					turbo_stream.append("flash", partial: "shared/flash"),

				]
			end
			format.html { redirect_to root_path }
		end
	end
end

