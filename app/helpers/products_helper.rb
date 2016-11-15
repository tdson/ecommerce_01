module ProductsHelper
  def display_product_status product
    product.sold_out? ? t("products.out") : t("products.available")
  end

  def get_class_by_status product
    product.sold_out? ? Settings.class_default : Settings.class_danger
  end
end
