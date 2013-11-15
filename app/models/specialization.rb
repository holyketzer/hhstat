class Specialization < ActiveRecord::Base
	has_many :vacancies

  scope :sorted, -> { order("priority") }

  def keywords_array
    keywords.split(';')
  end
end
