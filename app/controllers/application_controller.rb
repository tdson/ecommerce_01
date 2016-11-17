class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include CartsHelper
  before_action :count_cart_size

  protected
  def render_404
    render file: "#{Rails.root}#{Settings.file_path_404}",
      layout: false, status: Settings.http_status[:not_found]
  end
end
