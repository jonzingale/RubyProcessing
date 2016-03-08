class Mandelbrot
	Escape = 10**30.freeze
	Limit = 255.freeze

	def initialize(width, height)
		@width, @height = 4.2 / width, -2.5 / height
		@scale = 1 # scaling correctly requires a center.
	end

	def produce
		while @z.abs < Escape && @step < Limit
			@z = @z * @z + @point
			@step += 1
		end
	end

	def to_complex x, y
		z = Complex(x * @width, y * @height)
		z * @scale + Complex(-2.8, 1.2)
	end

	def get_color(w, h)
		@point = to_complex w, h
		@z, @step = 0, 0
		produce ; set_color
	end

	def set_color
		tuned_hue = Math.log(@step) * 50 + 15
		brightness = @step < 15 ? 0 : 100
		[tuned_hue.to_i, 100, brightness]
	end
end

CORES = 8.freeze

def setup
	size(displayWidth, displayHeight)
	colorMode(HSB,360,100,100)
	frame_rate 10
	background 0
  load_pixels

  CORES.times do |i| 
  	Thread.new { calculate i }
  end
end

def calculate t
	m = Mandelbrot.new(width, height)

	while t < width * height
		x, y = t % width, t / width
		hsb = m.get_color(x, y)
		pixels[t] = color(*hsb)
		t += CORES
	end
end

def draw
	update_pixels
end
