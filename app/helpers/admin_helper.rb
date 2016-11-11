module AdminHelper
  def admin_full_title page_title = ""
    base_title = t "layouts.admin.base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def get_role user
    role_names = [
      t("layouts.admin.role_0"),
      t("layouts.admin.role_1"),
      t("layouts.admin.role_2")
    ]
    user.role ? role_names[user.role] : t("layouts.admin.role_2")
  end
end
