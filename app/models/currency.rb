class Currency < ActiveRecord::Base
	def self.parse_many(json)
		json.each do |item|
			parse(item)
		end
	end

	def self.parse(json)
		code = json['code']
		curr = Currency.find_by_code(code) || Currency.new
		curr.code = code
		curr.rate = json['rate']
		curr.name = json['name']
		curr.save
		curr
	end

	def self.normalize(currency_code, value)
		if currency_code and value			
			value = value.to_f unless value.is_a? Numeric
			currency = Currency.find_by_code(currency_code)			
			value /= currency.rate			
			value
		else 
			nil
		end
	end	
end
