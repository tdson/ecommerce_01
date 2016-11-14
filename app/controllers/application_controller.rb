class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def load_category
    @categories = Category.depth_flow
  end
end
