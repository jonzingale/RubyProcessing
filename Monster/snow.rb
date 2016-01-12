class Snow
	Lambda = 9.freeze
	Density = 4.freeze
	Exp = 2.718281828.freeze

	attr_accessor :coords, :size, :circum
	def initialize(width, height)
		@coords = [rand(width), rand(height), 0, 0]
		@width, @height = width, height
		@size = 1 + rand(Lambda) # poisson ??
		# @size = @size * 10 * poisson + 1.0 
		# Todo: this REAL issue in not knowing how likely this or that size?
		
		@circum = get_circum
	end

	def get_circum
		@height*(0.2 + 0.8*@size /Lambda.to_f)
	end

	def drift
		x, y, s, t = @coords
		@coords = [(x + trip_x(s) * 3) % @width, 
							 (y + trip_y(t) * 5 * (1 - poisson)) % @circum, #2
							 s, t]
	end

	def fact(n) ; n==0 ? 1 : (1..n).inject(:*) ; end

	def poisson
		num = Density**@size
		denom = fact(@size) * Exp**Density
		num/denom.to_f
	end

	def trip_x(s) ; rand(20) == 1 ? (-1) ** rand(2) : s ; end
	def trip_y(t) ; rand(3) == 1 ? rand(2) : t ; end
end
