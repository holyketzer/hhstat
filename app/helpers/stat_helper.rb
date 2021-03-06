module StatHelper
  def get_count_by_month_in(year)
    Vacancy.with_itdev_specialization.in_year(year)
    .select("count(id),date_part('month', created) as month")
    .group("date_part('month', created)")
    .order("date_part('month', created)")
  end

  def get_count_by_year
    Vacancy.with_itdev_specialization.select("count(id),date_part('year',created) as year")
    .group("date_part('year', created)")
  end

  def get_count_by_month
    Vacancy.with_itdev_specialization.select("count(id),date_part('month',created) as month")
    .group("date_part('month', created)")
  end

  def get_count_by_specialization
    Vacancy.with_itdev_specialization.select("count(id),specialization_id")
    .group("specialization_id")
    .order("count(id) DESC")
  end

  def get_salary_distribution_in(year)
    all = Vacancy.with_itdev_specialization.in_year(year)
    .where("salary_to IS NOT NULL and salary_from IS NOT NULL and salary_from > 0 and salary_to > 0")
    .select("round((salary_to + salary_from)/2, -4) as salary, count(id)")
    .group("round((salary_to + salary_from)/2, -4)")
    .order("round((salary_to + salary_from)/2, -4)")

    low = all.take_while { |i| i.count > 1 && i.salary < 200000 }
    hi = all.drop(low.size)
    if hi.size > 0
      hi.first.count = hi.map{ |i| i.count }.inject{|sum, x| sum + x }
      low << hi.first
    end
    low
  end

  def get_mean_salary_by_specialization_in(year)
    Vacancy.with_itdev_specialization.in_year(year)
      .where("salary_to IS NOT NULL and salary_from IS NOT NULL and salary_from > 0 and salary_to > 0")
      .select("avg((salary_to + salary_from)/2) as salary, specialization_id")
      .group("specialization_id")
      .order('avg((salary_to + salary_from)/2)')
  end

  def get_salary_distribution_in_for(year, specialization_id)
    Vacancy.in_year(year).where('specialization_id = ?', specialization_id)
    .where("salary_to IS NOT NULL and salary_from IS NOT NULL and salary_from > 0 and salary_to > 0")
    .select("round((salary_to + salary_from)/2, -4) as salary, count(id)")
    .group("round((salary_to + salary_from)/2, -4)")
    .order("round((salary_to + salary_from)/2, -4)")
  end

  # trends

  def get_specialization_trend_in_for(year, specialization_id)
    Vacancy.in_year(year).where('specialization_id = ?', specialization_id)
    .select("count(id), date_part('month', created) as month")
    .group("date_part('month', created)")
    .order("date_part('month', created)")
  end

  def get_salary_distribution_for(specialization_id)
    Vacancy.where('specialization_id = ?', specialization_id)
    .select("count(id), date_part('year', created) as year")
    .group("date_part('year', created)")
    .order("date_part('year', created)")
  end

  # label helpres

  def labels_for_salary_distribution(data)
    labels = data.map { |a| a.salary.to_i/1000 }.map { |s| "#{s}..#{s+10}k" }
    labels[-1] = "> #{labels[-1].split('.')[0]}k" if labels.size > 1
    labels
  end

  def labels_for_months(data)
    month_names = I18n.t(:'date.standalone_month_names').compact
    data.map { |a| month_names[a.month-1] }
  end
end
