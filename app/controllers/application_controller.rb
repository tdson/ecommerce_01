class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  require "chatwork"

  before_action :count_current_item

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def send_chatwork_message message_body
    ChatWork.api_key = ENV["CHATWORK_API_KEY"]
    room_id = Settings.id_chatwork_group
    ChatWork::Message.create room_id: room_id, body: message_body
  end
end
