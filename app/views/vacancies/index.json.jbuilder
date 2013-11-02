json.array!(@vacancies) do |vacancy|
  json.extract! vacancy, :salary_from, :salary_to, :name, :area_id, :created, :employer_id
  json.url vacancy_url(vacancy, format: :json)
end
