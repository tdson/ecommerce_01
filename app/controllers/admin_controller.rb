class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin_application"
  load_and_authorize_resource
  before_filter :verify_admin_or_mod

  private
  def verify_admin_or_mod
    unless current_user.is_admin_or_mod?
      redirect_to root_url
    end
  end
end
