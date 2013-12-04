module StatHelper
	def get_count_by_month_in(year)
		Vacancy.with_itdev_specialization.in_year(year).select("count(id),date_part('month', created) as month").group("date_part('month', created)").order("date_part('month', created)")
	end

	def get_salary_distribution_in(year)
		Vacancy.with_itdev_specialization.in_year(year).where("salary_to IS NOT NULL and salary_from IS NOT NULL and salary_from > 0 and salary_to > 0").select("round((salary_to + salary_from)/2, -4) as salary, count(id)").group("round((salary_to + salary_from)/2, -4)").order("round((salary_to + salary_from)/2, -4)")
	end

	def get_count_by_year
		Vacancy.with_itdev_specialization.select("count(id),date_part('year',created) as year").group("date_part('year', created)")
	end

	def get_count_by_month
		Vacancy.with_itdev_specialization.select("count(id),date_part('month',created) as month").group("date_part('month', created)")
	end

  def get_count_by_specialization
    Vacancy.with_itdev_specialization.select("count(id),specialization_id").group("specialization_id").order("count(id) DESC")
  end
end
