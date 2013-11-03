class Vacancy < ActiveRecord::Base
  scope :in_year, ->(year) do
    y = DateTime.new(year)
    where("created >= ? and created < ?", y, y.next_year)
  end
  scope :current_year, -> { in_year(Date.today.year) }
  scope :prev_year, -> { in_year(Date.today.year-1) }

  scope :in_month, ->(month) { 
    m = Date.new(Date.today.year, month)
    where("created >= ? and created < ?", m, m.next_month)
  }
  scope :current_month, -> { in_month(Date.today.month) }

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

  def self.isITVacancy(data)
    data["specializations"].any? { |spec| spec["id"] == "1.221" }
  end

  def self.parse_all(start)
    query = "https://api.hh.ru/vacancies/%s"
    require 'rest_client'
    id = start.to_i
    while true
      logger.info ">> try to get vacancy #{id}"
      begin
        response = RestClient.get query % id
        if response.code == 200
          data = JSON.parse(response.to_s)
          if isITVacancy(data)
            new_vacancy = Vacancy.parse(data)
            if !new_vacancy.save                
              logger.error "error on parse request"
            end
          else
            logger.info "#{id} is not IT vacancy"
          end
        else
          logger.error "error on get request"
        end
      rescue
        logger.error "query fall"
      end
      id += 1
      #sleep 2
    end
  end
end
