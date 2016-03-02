class Mandelbrot
	Escape = 10**30.freeze
	Limit = 255.freeze

	attr_reader :point, :step, :z, :hsb, :coords
	def escape? ; Escape < @z.abs || Limit < @step ; end
	def produce ; blink until escape? ; end

	def initialize(width, height)
		@width, @height = width.to_f, height.to_f
	end

	def to_scaled_complex x, y
		# Complex(0.7 - y / @width * 3, x / @height * 4 - 2.0)
		# Complex(0.7 - y / @height * 3, x / @width * 4 - 2.0)
		Complex(0.7 - y / @height * 3, x / @width * 4 - 2.0)

	end

	def get_color(w, h)
		@point = to_scaled_complex h, w
		@z, @step = 0, 0
		produce
		set_color
	end

	def set_color
		tuned_hue = Math.log(@step) * 50 + 10
		brightness = @step < 15 ? 0 : 100
		@hsb = [tuned_hue, 100, brightness]
	end

	def blink(c=1)
		@z = @z * @z + @point
		@step += 4 # 1
	end
end

CORES = 8.freeze

def setup
	text_font create_font("SanSerif",100)

	size(displayWidth, displayHeight)
	colorMode(HSB,360,100,100,100)
	background(0) ; frame_rate 20
  load_pixels

  @mandelbrot = Mandelbrot.new(width, height)
  @pairs = [*0..height].product([*0..width])

  @threads = []
  CORES.times{|i| @threads << Thread.new { calculate i }}
end

def calculate(thread=nil)
		@pairs.each do |x, y|
			@mandelbrot.get_color x, y
			hsb = @mandelbrot.hsb
			pixels[x*width+y] = color(*hsb)
		end

	calculate thread
end

def draw
	update_pixels
end
