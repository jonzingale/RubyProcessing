class Mandelbrot
	Escape = 10**30.freeze
	Limit = 250.freeze

	attr_reader :point, :step, :z

	def initialize
		@point = Complex(ranged_rand * 1.4 - 0.5, ranged_rand * 1.2)
		@step, @z =  0, 0
		produce
	end

	def escape? ; Escape < @z.abs || Limit < @step ; end
	def ranged_rand ; (-1)**rand(2) * rand ; end
	def produce ; blink until escape? ; end

	def blink(c=1)
		@z = @z ** 2 + @point
		@step += 1
	end
end

def setup
	size(displayWidth, displayHeight)
	@w, @h = width/2.0 + 200, height/2.0 - 50
	colorMode(HSB,360,100,100,100)
  frame_rate 20
	background 0
  load_pixels

  8.times{Thread.new{ calculate_points }}
end

def calculate_points
	10_000_000.times do
		it = Mandelbrot.new	
		coords = it.point * 330 + Complex(@w, @h)

		tuned_color = Math.log(it.step) * 59 + 10
		filtered_bright = it.step < 15 ? 0 : 100
		
		c = color(tuned_color, 100, filtered_bright)
		x, y = coords.rect.map(&:to_i)

		pixels[x+width*y] = c
	end
end

def draw
	update_pixels
end
