class Vacancy < ActiveRecord::Base
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
end
