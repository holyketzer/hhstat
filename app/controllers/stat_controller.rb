class StatController < ApplicationController
  include StatHelper

  def count_by_month_in
  	@year = params[:year].to_i || Date.today.year
  	data = get_count_by_month_in(@year)
  	if data.any?
  		@months = '"' + data.map { |a| Date::MONTHNAMES[a.month] }.inject { |s,a| s + '", "' + a } + '"'
		  @values = data.map { |a| a.count }.inject { |s,a| "#{s}, #{a}" }
	  end
	  @years = Vacancy.years
  end

  def salary_distribution_in
  	@year = params[:year].to_i || Date.today.year
  	data = get_salary_distribution_in(@year)
  	if data.any?
  		@salaries = '"' + data.map { |a| a.salary.to_i.to_s }.inject { |s,a| s + '", "' + a } + '"'
		  @values = data.map { |a| a.count }.inject { |s,a| "#{s}, #{a}" }
  	end
  	@years = Vacancy.years
  end

  def count_by_year
    data = get_count_by_year
    if data.any?
      @count = data.map { |a| a.count }.inject { |s,a| "#{s}, #{a}" }
      @years = data.map { |a| a.year.to_i }.inject { |s,a| "#{s}, #{a}"}
    end
  end

  def count_by_month
    data = get_count_by_month
    if data.any?
      @count = data.map { |a| a.count }.inject { |s,a| "#{s}, #{a}" }
      @months = '"' + data.map { |a| Date::MONTHNAMES[a.month] }.inject { |s,a| s + '", "' + a } + '"'
    end
  end

  def count_by_specialization
    data = get_count_by_specialization
    if data.any?
      @count = data.map { |a| a.count }.inject { |s,a| "#{s}, #{a}" }
      @specializations = '"' + data.map { |a| a.specialization.name }.inject { |s,a| s + '", "' + a } + '"'
    end
  end

  def count_by_class
    @count = [Vacancy.pending_alghorithm_improvement.count, Vacancy.with_itdev_specialization.count, Vacancy.with_not_itdev_specialization.count]
    @labels = ['Пока не определено', 'IT разработка', 'Не IT разработка']
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def vacancy_params
      params.permit(:year)
    end
end
