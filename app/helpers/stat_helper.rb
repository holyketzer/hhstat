module StatHelper
	def year_by_month(year)
		Vacancy.in_year(year).to_a.group_by { |v| v.created.beginning_of_month }.map { |k,v| [k,v.size] }.sort_by { |v| v[0] }
		#select("date(created_at) as ordered_date, sum(price) as total_price").group("date(created_at)") }
	end
end
