require 'rest_client'

class Vacancy < ActiveRecord::Base
  belongs_to :specialization

  scope :in_year, ->(year) { where("date_part('year', created) = ?", year) }
  scope :current_year, -> { in_year(Date.today.year) }
  scope :prev_year, -> { in_year(Date.today.year-1) }

  scope :in_month, ->(month) { where("date_part('month', created) = ?", month) }
  scope :current_month, -> { in_month(Date.today.month) }

  scope :not_classified, -> { where("specialization_id IS NULL") }
  scope :classified, -> { where("specialization_id IS NOT NULL") }
  scope :pending_alghorithm_improvement, -> { where("specialization_id = ?", Specialization.pending_alghorithm_improvement_id) }
  scope :with_itdev_specialization, -> { classified.where("specialization_id != ? and specialization_id != ?", Specialization.not_itdev_id, Specialization.pending_alghorithm_improvement_id) }
  scope :with_not_itdev_specialization, -> { where("specialization_id = ?", Specialization.not_itdev_id) }

  def self.years
    Vacancy.minimum("created").year..Vacancy.maximum("created").year
  end

  def self.parse(json)    

    vacancy = Vacancy.find_by_id(json['id']) || Vacancy.new
    vacancy.id = json['id']
    if json['salary']
      currency_code = json['salary']['currency']
      vacancy.salary_to = Currency.normalize(currency_code, json['salary']['to'])
      vacancy.salary_from = Currency.normalize(currency_code, json['salary']['from'])
      end
    vacancy.name = json['name']
    vacancy.area_id = json['area']['id']
    vacancy.created = json['created_at']
    vacancy.employer_id = json['employer']['id']
    vacancy
  end

  def self.is_IT_vacancy(data)
    data["specializations"].any? { |spec| spec["id"] == "1.221" }
  end 

  def self.get_vacancy(id)    
    query_get_vacancy = "https://api.hh.ru/vacancies/%s"
    logger.info ">> try to get vacancy #{id}"    
    begin      
      response = RestClient.get query_get_vacancy % id
      if response.code == 200
        data = JSON.parse(response.to_s)
        if is_IT_vacancy(data)
          new_vacancy = Vacancy.parse(data)
          new_vacancy.save                          
        else
          logger.info "#{id} is not IT vacancy"
        end
      else
        logger.error "error on get request"
      end
    rescue
      logger.error "query fall"
    end
  end

  def self.parse_all(from_id, to_id = nil)    
    id = from_id.to_i
    while true
      get_vacancy(id)
      id += 1
      break if to_id and id > to_id.to_i
    end
  end

  def self.parse_latest(external_logger)
    external_logger ||= logger
    per_page = 100
    page = 0
    query = "https://api.hh.ru/vacancies?specialization=1.221&per_page=#{per_page}&page=%s"    
    while true
      external_logger.info ">> try to get #{query % page}"
      response = RestClient.get query % page
      if response.code == 200
        arr = JSON.parse(response.to_s)
        arr["items"].each do |data|
          new_vacancy = Vacancy.parse(data)
          if !new_vacancy.save                
            external_logger.error "error on parse request"
          end
        end
        page += 1
        external_logger.info ">> next page = #{page}/#{arr["pages"].to_i}"
        break if page >= arr["pages"].to_i
      else
        external_logger.error "error on get request"
      end
      sleep 5 
    end    
    external_logger.info "sucessefully finished"
  end

  def self.classify_all(external_logger)
    external_logger ||= logger
    default = Specialization.pending_alghorithm_improvement
    specializations = Specialization.sorted
    not_classified.find_each(batch_size: 1000) do |vacancy|
      external_logger.info "Finding spec for vacancy #{vacancy.id} #{vacancy.name}"
      Specialization.classify(vacancy, specializations, default)
      external_logger.info "Vacancy #{vacancy.id} assigned with spec #{vacancy.specialization.name}"
      unless vacancy.save
        external_logger.error "error on save #{vacancy.id}"
      end
    end
  end
end
