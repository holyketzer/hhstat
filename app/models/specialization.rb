class Specialization < ActiveRecord::Base
	has_many :vacancies

  scope :sorted, -> { order("priority") }

  def self.not_itdev
    select(:id).find_by("priority = -1")
  end

  def self.not_itdev_id
    not_itdev.id
  end

  def self.pending_alghorithm_improvement
  	select(:id).find_by("priority = -2")
  end

  def self.pending_alghorithm_improvement_id
  	pending_alghorithm_improvement.id
  end

  def keywords_array
    keywords.split(';')
  end

  def self.classify(vacancy, specializations, default)
  	vacancy.specialization = default
    specializations.each do |spec|
      if spec.keywords_array.any? { |keyword| vacancy.name =~ Regexp.new(Regexp.quote(keyword), "i") }        
        vacancy.specialization = spec                    
        break
      end      
    end    
  end
end
