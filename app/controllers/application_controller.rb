class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include CartsHelper
  require "chatwork"
  before_action :count_cart_size
  helper_method [:recent_products, :last_viewed_product]

  def recent_products
    @recent_products ||= RecentProducts.new cookies
  end

  def last_viewed_product
    @recent_products.reverse.second
  end

  protected
  def render_404
    render file: "#{Rails.root}#{Settings.file_path_404}",
      layout: false, status: Settings.http_status[:not_found]
  end

  def send_chatwork_message message_body
    ChatWork.api_key = ENV["CHATWORK_API_KEY"]
    room_id = Settings.id_chatwork_group
    ChatWork::Message.create room_id: room_id, body: message_body
  end
end
