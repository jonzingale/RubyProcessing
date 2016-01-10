class Snow
	Lambda = 8.freeze

	attr_accessor :coords, :size, :circum
	def initialize(width, height)
		@coords = [rand(width), rand(height), 0, 0]
		@width, @height = width, height
		@size = 1 + rand(Lambda)
		@circum = get_circum
	end

	def get_circum
		@height*(0.2 + 0.8*@size /Lambda.to_f)
	end

	def drift
		x, y, s, t = @coords
		@coords = [(x + trip_x(s) * 3) % @width, 
							 (y + trip_y(t) * 2) % @circum, 
							 s, t]
	end

	def trip_x(s) ; rand(20) == 1 ? (-1) ** rand(2) : s ; end
	def trip_y(t) ; rand(3) == 1 ? rand(2) : t ; end
end
# require 'byebug'
# it = Snow.new(1200,800,1)
# it.drift
# byebug ; 4