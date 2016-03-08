class Mandelbrot
	Escape = 10**20.freeze
	Limit = 250.freeze

	attr_reader :point, :iterate, :z
	def escape? ; Escape < @z.abs || Limit < @iterate ; end
	def produce ; blink until escape? ; end

	def set_point(pt)
		@z, @iterate, @point = 0, 0, pt
		produce
	end

	def blink(c=1)
		@z = @z ** 2 + @point
		@iterate += 1
	end
end

def setup
	size(displayWidth, displayHeight)
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
		
		c = color(@it.iterate, 100, @it.iterate < 13 ? 0 : 100)
		coords = @unscalar * @it.point + Complex(@w+100, @h+20)
		x, y = coords.rect.map(&:to_i)
		set(*coords.rect, c)
	end
end
