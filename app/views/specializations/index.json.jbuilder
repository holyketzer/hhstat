json.array!(@specializations) do |specialization|
  json.extract! specialization, :name, :keywords
  json.url specialization_url(specialization, format: :json)
end
