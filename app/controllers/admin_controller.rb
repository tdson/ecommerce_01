class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin/layouts/admin_application"
end
