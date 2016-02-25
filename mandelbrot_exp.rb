	class Mandelbrot
		Escape = 10**20.freeze
		Limit = 250.freeze

		attr_reader :point, :iterate, :z

		def initialize
			@point = Complex(0,0)
			@z, @iterate = 0, 0
			produce
		end

		def set_point(pt)
			@z, @iterate = 0, 0
			@point = pt
			produce
		end

		def escape? ; Escape < @z.abs || Limit < @iterate ; end
		def produce ; blink until escape? ; end

		def blink(c=1)
			@z = @z ** 2 + @point
			@iterate += 1
		end
	end

	def setup
		text_font create_font("SanSerif",100)

		size(displayWidth, displayHeight)
		@w, @h = width/2.0 + 200, height/2.0 - 20
		colorMode(HSB,360,100,100,100)
		background(0)
    frame_rate 2

    @it = Mandelbrot.new

    @img = createImage(width, height, RGB)
		@img.loadPixels()
		@count = @img.pixels.count
		image(@img, 0, 0)
	end

	def rescale x, y, step
		[x * step/1920.0 * 4 - 2, y * step/1080.0 * 2.4 - 1.2]
	end

	def draw
		step = 15
		(1...height/step).each do |y|
			(1...(@w+20)/step).each do |x|
				resized = rescale(x,y,step)
				z = Complex(*resized)
				@it.set_point(z)
		
				coords = @it.point * 300 + Complex(@w, @h)
				c = color(@it.iterate, 100, @it.iterate < 13 ? 0 : 100)
				set(*coords.rect, c)
			end
		end
	end
