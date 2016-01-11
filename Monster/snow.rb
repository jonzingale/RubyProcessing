class Snow
	Lambda = 8.freeze
	Density = 100.freeze
	Exp = 2.718281828.freeze

	attr_accessor :coords, :size, :circum
	def initialize(width, height)
		@coords = [rand(width), rand(height), 0, 0]
		@width, @height = width, height
		@size = 1 + rand(Lambda) # poisson ??
		@size = @size * poisson + 1
		@circum = get_circum
	end

	def get_circum
		@height*(0.2 + 0.8*@size /Lambda.to_f)
	end

	def drift
		x, y, s, t = @coords
		@coords = [(x + trip_x(s) * 3) % @width, 
							 (y + trip_y(t) * 5 * poisson) % @circum, #2
							 s, t]
	end

	def fact(n) ; n==0 ? 1 : (1..n).inject(:*) ; end

	def poisson
		num = Density**@size
		denom = fact(@size) * Exp**Density
		1 - num/denom.to_f
	end

	def trip_x(s) ; rand(20) == 1 ? (-1) ** rand(2) : s ; end
	def trip_y(t) ; rand(3) == 1 ? rand(2) : t ; end
end
