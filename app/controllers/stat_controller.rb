class StatController < ApplicationController
  include StatHelper

  before_filter do
    @year = params.has_key?(:year) ? params[:year].to_i : Date.today.year
  end

  def count_by_month_in
  	data = get_count_by_month_in(@year)
  	if data.any?  		
		  @values = data.map { |a| a.count }

      month_names = I18n.t(:'date.standalone_month_names').compact
      @labels = data.map { |a| month_names[a.month-1] }
	  end
	  @years = Vacancy.years
  end

  def salary_distribution_in  	
  	data = get_salary_distribution_in(@year)
  	if data.any?
  		@labels = data.map { |a| a.salary.to_i }
		  @values = data.map { |a| a.count }
  	end
  	@years = Vacancy.years
  end

  def count_by_year
    data = get_count_by_year
    if data.any?
      @values = data.map { |a| a.count }
      @labels = data.map { |a| a.year }
    end
  end

  def count_by_month
    data = get_count_by_month
    if data.any?
      @years = Vacancy.years
      @values = data.map { |a| a.count }
      
      month_names = I18n.t(:'date.standalone_month_names').compact
      @labels = data.map { |a| month_names[a.month-1] }
    end
  end

  def count_by_specialization
    data = get_count_by_specialization
    if data.any?
      @values = data.map { |a| a.count }
      @labels = data.map { |a| a.specialization.name }
    end
  end

  def count_by_class
    @values = [Vacancy.pending_alghorithm_improvement.count, Vacancy.with_itdev_specialization.count, Vacancy.with_not_itdev_specialization.count]    
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def vacancy_params
      params.permit(:year)            
    end
end
