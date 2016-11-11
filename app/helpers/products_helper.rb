module ProductsHelper
  def get_product_status product
    product.sold_out? ? t("products.out") : t("products.available")
  end

  def status_class product
    product.sold_out? ? Settings.class_default : Settings.class_danger
  end
end
