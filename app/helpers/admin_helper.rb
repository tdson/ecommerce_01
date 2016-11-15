module AdminHelper
  def admin_full_title page_title = ""
    base_title = t "layouts.admin.base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
