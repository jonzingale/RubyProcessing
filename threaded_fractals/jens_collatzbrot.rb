class Mandelbrot
	Escape = 1000.freeze
	# Limit = 250.freeze
	Limit = 30
	PI = 3.1415926

	attr_reader :point, :iterate, :z
	# def escape? ; Escape < @z.abs || Limit < @iterate ; end
	def escape? ; Escape < @z.abs || Limit < @iterate ; end

	def produce ; blink until escape? ; end

	def set_point(pt)
		@z, @iterate, @point = 100, 0, pt
		produce
	end

	def blink(c=1)
		# @z = @z ** 2 + @point
		@z = jens + @point
		@iterate += 1
	end

	def jens
		trig = Complex(Math.cos(PI*@z.real),Math.cos(PI*@z.imag))
		0.25*(1+4*@z-(1+2*@z)*trig)
	end
end

def setup
	size(displayWidth/2.0, displayHeight/2.0)
	@w, @h = width/2.0, height/2.0
	colorMode(HSB,360,100,100,100)
	background(0); @y = 0
  frame_rate 10

  @it = Mandelbrot.new
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

		c = color(@it.iterate, 100, @it.iterate < 0 ? 0 : 100)		
		# c = color(@it.iterate, 100, @it.iterate < 13 ? 0 : 100)
		coords = @unscalar * @it.point + Complex(@w+100, @h+20)
		x, y = coords.rect.map(&:to_i)
		set(*coords.rect, c)
	end
end