class JensCollatz
	Escape = 10**10.freeze
	Limit = 255.freeze

	attr_reader :point, :iterate, :z
	def escape? ; Escape < @z.abs || Limit < @iterate ; end
	def produce ; blink until escape? ; end

	def set_point(pt)
		@z, @iterate, @point = 0, 0, pt
		produce
	end

	def blink(c=1)
		# @z = @z ** 2 + @point
		@z = function + @point
		@iterate += 1
	end

	def function
		trig = Complex(Math.cos(PI*@z.real),
									 Math.cos(PI*@z.imag))
		0.25*(1+4*@z-(1+2*@z)*trig)
	end
end

def setup
	size(displayWidth, displayHeight)
	@w, @h = width/2.0, height/2.0
	colorMode(HSB,360,100,100,100)
	background(0); @y = 0
  frame_rate 1

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

		c = color(@it.iterate, 100, @it.iterate < 0 ? 0 : 100)	# < valid colors
		coords = @unscalar * @it.point + Complex(@w+100, @h+20)
		x, y = coords.rect.map(&:to_i)
		set(*coords.rect, c)
	end
end