json.array!(@welcomes) do |welcome|
  json.extract! welcome, 
  json.url welcome_url(welcome, format: :json)
end
