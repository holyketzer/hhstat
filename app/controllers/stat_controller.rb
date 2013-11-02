class StatController < ApplicationController
  include StatHelper

  def time
  	data = current_year_by_month
  	@months = '"' + data.map { |a| Date::MONTHNAMES[a[0].month] }.inject { |s,a| s + '", "' + a } + '"'
	@values = data.map { |a| a[1] }.inject { |s,a| "#{s}, #{a}" }
  end
end
