class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes! user_params
      flash[:success] = t ".success"
      redirect_to :back || root_path
    else
      flash[:danger] = t ".fails"
      binding.pry
      render :edit
    end
  end

  private
  def load_user
    @user = User.find_by_id params[:id]
    unless @user
      flash[:danger] = t "users.load_fails"
      redirect_to :back || root_path
    end
  end

  def user_params
    params.require(:user)
      .permit :name, :gender, :phone_number, :address, :chatwork_id, :email,
        :password, :password_confirmation, :current_password
  end
end
