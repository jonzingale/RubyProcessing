class Snow
	Lambda = 10.freeze
	Density = 4.freeze
	Exp = 2.718281828.freeze

	attr_accessor :coords, :size, :circum
	def initialize(width, height, size=nil)
		@coords = [rand(width), rand(height), 0, 0]
		@width, @height = width, height
		@size = size || 1 + rand(Lambda)
		@circum = get_circum
	end

	def fact(n) ; n==0 ? 1 : (1..n).inject(:*) ; end
	def get_circum ; @height*(0.55 + 0.45*@size /Lambda.to_f) ; end

	def drift
		# XXXXX y+5 could be adjust with * and things get weird.
		x, y, s, t = @coords
		@coords = [(x + trip_x(s) * 3) % @width,
							 (y+3 + trip_y(t) * 5 * (1 - poisson*5)) % @circum,
							 s, t]
	end

	def poisson
		num = Density**@size
		denom = fact(@size) * Exp**Density
		num/denom.to_f
	end

	def trip_x(s) ; rand(20) == 1 ? (-1) ** rand(2) : s ; end
	def trip_y(t) ; rand(3) == 1 ? rand(2) : t ; end
end
