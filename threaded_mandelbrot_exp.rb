class Mandelbrot
	Escape = 10**30.freeze
	Limit = 255.freeze

	def escape? ; Escape < @z.abs || Limit < @step ; end
	def produce ; blink until escape? ; end

	def initialize(width, height)
		@width, @height = 4.2 / width, 3.0 / height
	end

	def to_scaled_complex x, y
		Complex(2 - y * @height, x * @width - 1.2)
	end

	def get_color(w, h)
		@point = to_scaled_complex w, h
		@z, @step = 0, 0
		produce
		set_color
	end

	def set_color
		tuned_hue = Math.log(@step) * 50 + 10
		brightness = @step < 1 ? 0 : 100 #  < 15
		[tuned_hue, 100, brightness]
	end

	def blink
		@z = @z * @z + @point
		@step += 1
	end
end

CORES = 8.freeze

def setup
	text_font create_font("SanSerif",10)
	# size(displayWidth, displayHeight)
	size(displayWidth/3, displayHeight/3)
	colorMode(HSB,360,100,100)
  @size = width * height
	frame_rate 10 ; @t = 0
	background(0)
  load_pixels

  @mandelbrot = Mandelbrot.new(width, height)

  @threads = []
  (0...CORES).each{|i| @threads << Thread.new { calculate i } }
end

def limit? ; @t < @size ; end

def calculate t
	while limit?
		x, y = (t+1) % width, width / (t+1)

		hsb = @mandelbrot.get_color x, y
		pixels[t] = color(*hsb)

		t += CORES
		@t = t
	  
	  begin
	  	calculate t
	  rescue
	  	calculate t
	  end
	end

end

def draw
	update_pixels
end
