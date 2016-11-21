module ApplicationHelper
  def full_title page_title = ""
    base_title = t ".base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def active_class link_path
    request.original_fullpath.include?(link_path) ? Settings.class_active : ""
  end

  def to_currency number
    ActiveSupport::NumberHelper.number_to_currency number, unit: t("currency")
  end
end
