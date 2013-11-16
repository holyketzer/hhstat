class Specialization < ActiveRecord::Base
	has_many :vacancies

  scope :sorted, -> { order("priority") }

  def self.not_itdev_id
    select(:id).find_by("priority < 0").id
  end

  def keywords_array
    keywords.split(';')
  end
end
