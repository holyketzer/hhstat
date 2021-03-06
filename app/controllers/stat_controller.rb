class StatController < ApplicationController
  include StatHelper

  caches_page :count_by_month_in, :salary_distribution_in, :count_by_year, :count_by_month, :count_by_specialization, :count_by_class, :mean_salary_by_specialization, :salary_distribution_in_for, :specialization_trend_in_for, :specialization_trend_for

  before_filter do
    @year = params.has_key?(:year) ? params[:year].to_i : Date.today.year
    @specialization_name = params[:specialization_name].to_s if params.has_key?(:specialization_name)
  end

  def count_by_month_in
    data = get_count_by_month_in(@year)
    if data.any?
      @values = data.map { |a| a.count }
      @labels = labels_for_months(data)
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
      @labels = labels_for_months(data)
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

  def salary_distribution_in
    data = get_salary_distribution_in(@year)
    if data.any?
      @labels = labels_for_salary_distribution(data)
      @values = data.map { |a| a.count }
    end
    @years = Vacancy.years
  end

  def mean_salary_by_specialization_in
    specs = Specialization.all.to_a
    data = get_mean_salary_by_specialization_in(@year)
    if data.any?
      @values = data.map { |a| a.salary.to_i }
      @labels = data.map { |a| specs.select { |s| s.id == a.specialization_id }.first.name }
    end
    @years = Vacancy.years
  end

  def salary_distribution_in_for
    specialization = load_specializations
    data = get_salary_distribution_in_for(@year, specialization.id)
    if data.any?
      @values = data.map { |a| a.count }
      @labels = labels_for_salary_distribution(data)
    end
    @years = Vacancy.years
  end

  # trends

  def specialization_trend_in_for
    specialization = load_specializations
    data = get_specialization_trend_in_for(@year, specialization.id)
    if data.any?
      @values = data.map { |a| a.count }
      @labels = labels_for_months(data)
    end
    @years = Vacancy.years
  end

  def specialization_trend_for
    specialization = load_specializations
    data = get_salary_distribution_for(specialization.id)
    if data.any?
      @values = data.map { |a| a.count }
      @labels = data.map { |a| a.year }
    end
    @years = Vacancy.years
  end

  private
    def load_specializations
      @specializations = Specialization.ui_sorted.select(:name).map { |s| s.name }
      @specialization_name ||= @specializations.sample
      Specialization.find_by_name(@specialization_name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacancy_params
      params.permit(:year, :specialization_name)
    end
end
