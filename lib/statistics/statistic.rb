class Statistic
  class << self
    def range
      [
        [I18n.t("admin.statistics.range_7_days"), :one_week],
        [I18n.t("admin.statistics.range_30_days"), :one_month]
      ]
    end

    def default_range
      self.range[0][1]
    end
  end
end
