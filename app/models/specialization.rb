class Specialization < ActiveRecord::Base
	has_many :vacancies

  def keywords_array
    keywords.split(';')
  end
end
