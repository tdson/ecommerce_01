class Admin::CategoriesController < AdminController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode
  before_action :load_category, only: [:destroy, :edit, :update]

  def index
    @categories = Category.nested_set_scope.select('id, name, description, parent_id')
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "products.admin.new.create_success"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "categories.admin.edit.update_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "categories.admin.edit.update_fail"
      render :edit
    end
  end

  def destroy
    if @category.products.present? || @category.rgt-@category.lft != 1
      flash[:danger] = t "categories.admin.index.delete_fail"
    else
      if @category.destroy
        flash[:success] = t("categories.admin.index.delete_success")
      else
        flash[:danger] = t "categories.admin.index.delete_fail"
      end
    end
    redirect_to admin_categories_path
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "categories.admin.index.not_found"
      redirect_to admin_categories_path
    end
  end

  def category_params
    params.require(:category).permit :name, :description, :parent_id
  end
end
