class MessageParser
	def initialize(type, regexp, defaults = {})
		@type = type
		@regexp = regexp
		@defaults = defaults
	end

	def parse(message)
		if message =~ @regexp
			event = {
				type: @type,
				message: message
			}
			results = @regexp.match(message)
			results.names.each do |name|
				event[name.to_sym] = results[name]
			end
			@defaults.each_pair do |key, value|
				event[key.to_sym] = event[key.to_sym] || value
			end
			return event
		end
	end
end