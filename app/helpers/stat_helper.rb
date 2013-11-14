module StatHelper
	def get_count_by_month_in(year)
		Vacancy.in_year(year).select("count(id),date_part('month', created) as month").group("date_part('month', created)").order("date_part('month', created)")
	end

	def salary_distrib(year)
		Vacancy.select("salary_to, salary_from").where("salary_to IS NOT NULL and salary_from IS NOT NULL").in_year(year).map {|v| ((v.salary_from + v.salary_to)/2).to_i.round(-4)}.group_by { |v| v }.map { |k,v| [k,v.size] }.sort_by { |v| v[0] }
	end

	def get_count_by_year
		Vacancy.select("count(id),date_part('year',created) as year").group("date_part('year', created)")
	end

	def get_count_by_month
		Vacancy.select("count(id),date_part('month',created) as month").group("date_part('month', created)")
	end
end
