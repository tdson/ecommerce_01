class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_product
  before_action :load_rating

  def create
    @rating.update_attributes rating_params
    @rating = Rating.average_of @product_id
    respond_to do |format|
      format.js
      format.html {redirect_to product_path @product_id}
    end
  end

  private
  def verify_product
    @product_id = params[:product_id]
    redirect_to :back unless Product.find_by_id @product_id
  end

  def load_rating
    @rating = current_user.ratings.find_by(product_id: @product_id) ||
      current_user.ratings.build
  end

  def rating_params
    params.permit :rating, :product_id
  end
end
