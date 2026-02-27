class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  include Authentication
  include Pagy::Method

  layout :set_layout

  private

  def set_layout
    Current.user ? "dashboard" : "application"
  end
end
