class Admin::ProductsController < AdminController
  before_action :load_product, only: [:destroy, :edit, :update]

  def index
    @products = Product.alphabet.page(params[:page])
      .per Settings.products_per_page
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_a.to_csv }
      format.xls do
        filename = t("products.admin.index.products")+
          "_#{Time.now.strftime(Settings.time_format)}."+
          t("products.admin.index.xls")
        send_data(Product.all.to_a.to_xls(except: [:created_at, :updated_at]),
          type: Settings.type_xls, filename: filename)
      end
    end
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @categories = Category.all
    if !product_params[:name].nil?
      @product = Product.new product_params
      if @product.save
        flash[:success] = t "products.admin.new.create_success"
        redirect_to admin_products_path
      else
        render :new
      end
    else
      if params[:product][:file].present?
        Product.import(params[:product][:file])
        redirect_to admin_products_path
        flash[:success] = I18n.t("products.admin.new.import_success")
      else
        flash[:warning] = I18n.t("products.admin.new.please_import")
        redirect_to new_admin_product_path
      end
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
    params.require(:product).permit :category_id,
      :name, :quantity, :description, :image, :price, :file
  end
end
