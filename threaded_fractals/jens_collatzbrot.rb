require 'cmath'
class JensCollatz
	PI = 3.1415926.freeze
	Escape = 10**3.freeze
	Limit = 255.freeze

	attr_reader :point, :iterate, :z
	def escape? ; Escape < @z.abs || Limit < @iterate ; end
	def produce ; blink until escape? ; end

	def set_point(pt)
		@z, @iterate, @point = 0, 0, pt
		produce
	end

	def blink(c=1)
		@z = function + @point
		@iterate += 1
	end

	def function
		x, y = @z.rect.map{|t|t * PI}
		cosp = Math.cos(x)*CMath.cosh(y)
		sinp = Math.sin(x)*CMath.sinh(y)
		trig = Complex(cosp,-sinp)
		(2+7*@z-(2+5*@z)* trig)/4.0
	end
end

def setup
	size displayWidth/4, displayHeight/4
	@w, @h = width/2.0, height/2.0
	colorMode(HSB,360,100,100,100)
	background(0); @y = 0
  frame_rate 10

  @it = JensCollatz.new
  @unscalar = Complex(width / 7, height / 7)
end

def rescale x, y
	[x / width.to_f * 4 - 2, y / height.to_f * 2.4 - 1.2 ]
end

def draw
	@y = @y + 1 % height

	width.times do |x|
		resized = rescale(x, @y)
		z = Complex(*resized)
		@it.set_point(z)

		c = color(@it.iterate+200, 100, @it.iterate < 2 ? 0 : 100)	# < valid colors
		coords = @unscalar * @it.point + Complex(@w+100, @h+20)
		x, y = coords.rect.map(&:to_i)
		set(*coords.rect, c)
	end
end