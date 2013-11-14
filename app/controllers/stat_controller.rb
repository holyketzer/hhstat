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

  def distrib
  	@year = params[:year].to_i || Date.today.year
  	data = salary_distrib(@year)
  	if data.any?
  		@salaries = '"' + data.map { |a| a[0].to_s }.inject { |s,a| s + '", "' + a } + '"'
		  @values = data.map { |a| a[1] }.inject { |s,a| "#{s}, #{a}" }
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def vacancy_params
      params.permit(:year)
    end
end
