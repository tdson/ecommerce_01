class Admin::UsersController < AdminController
  before_action :load_user, only: :destroy

  def index
    @users = User.search_name_or_email(params[:q])
      .order_by_name
      .page(params[:page])
      .per Settings.user_per_page
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fails"
    end
    redirect_to admin_users_path
  end

  private
  def load_user
    @user = User.find_by_id params[:id]
    unless @user
      flash[:danger] = t "admin.users.load_fails"
      redirect_to admin_users_path
    end
  end
end
