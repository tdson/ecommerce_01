class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin/admin_application"
end
