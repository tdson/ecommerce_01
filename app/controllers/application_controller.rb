class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def render_404
    render file: "#{Rails.root}#{Settings.file_path_404}",
      layout: false, status: Settings.http_status[:not_found]
  end
end
