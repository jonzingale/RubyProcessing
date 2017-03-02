class Lorenz
	Eball = 0.0009
	attr_reader :x, :y, :z, :color
	def initialize(x=nil, y=nil, z=nil, color=nil)
		@color = color || [rand(360), 80, 90, 70]
		@x = x||rand(17) # -18 < x <18
		@y = y||rand(23) # -24 < y < 24
		@z = z||rand(44) # 4 < z < 45
	end

	def dx ; 10 * (@y - @x) ; end
	def dy ; @x * (28 - @z) - @y ; end
	def dz ; @x * @y - @z * 8 / 3.0  ; end

	def blink
		[@x = Eball*dx + @x,
		 @y = Eball*dy + @y,
		 @z = Eball*dz + @z]
	end

	def test(attractor)
		puts "#{(0...10).map{ attractor.blink }}"
	end
end

# uncomment when testing
# it = Lorenz.new
# it.blink
# require 'byebug'
# byebug ; nil