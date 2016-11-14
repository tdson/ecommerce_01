class Admin::ProductsController < ApplicationController
  layout "admin_application"
  before_action :load_product, only: [:destroy, :edit, :update]

  def index
    @products = Product.alphabet.page(params[:page]).
      per Settings.products_per_page
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @categories = Category.all
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "products.admin.new.create_success"
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit_product
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "products.admin.edit.update_success"
      redirect_to admin_products_path
    else
      flash[:danger] = t "products.admin.edit.update_fail"
      render :edit
    end
  end

  def destroy
    if @product.order_products.present?
      flash[:danger] = t "products.admin.index.delete_fail"
    else
      if @product.destroy
        flash[:success] = t("products.admin.index.delete_success")
      else
        flash[:danger] = t "products.admin.index.delete_fail"
      end
    end
    redirect_to admin_products_path
  end

  private
  def load_product
    @product = Product.find_by id: params[:id]
    unless @product
      flash[:danger] = t "products.admin.index.not_found"
      redirect_to root_url
    end
  end
  def product_params
    params.require(:product).permit :category_id, :name, :quantity, :description, :image, :price
  end
end
