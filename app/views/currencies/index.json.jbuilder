json.array!(@currencies) do |currency|
  json.extract! currency, :code, :name, :rate
  json.url currency_url(currency, format: :json)
end
