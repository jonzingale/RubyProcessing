require 'cmath'

class Collatz
	PI = 3.1415926.freeze
	# Escape = 10**1.2.freeze # nighttime
	Escape = 10**3.freeze # canyon

	Limit = 255.freeze

	def initialize(width, height)
		@width, @height = width.to_f, height.to_f
		@scale = [5, 5].map{|t| t * 0.1**0 } # zoom
	end

	def to_complex x, y
		s, r = @scale
		x = s * x / @width - s/2.0
		y = r/2.0 - r * y / @height
		z = Complex(x,y)
	end

	def collatz_like # canyon
		trig = @z.rect.map{|t| Math.cos(PI*t)}
		0.25*(1+4*@z-(1+2*@z)*Complex(*trig))
	end

	def produce
		while @z.abs < Escape && @step < Limit
			@z = collatz_like * @point
			@step += 0.2
		end
	end

	def get_color(w, h)
		@point = to_complex w, h
		@z, @step = 0, 0
		produce ; set_color
	end

	def set_color
		tuned_hue = Math.log(@step) * 40 + 10 # canyon
		# tuned_hue = Math.log(@step) * 50 + 10 # nighttime

		# brightness = @step < 2 ? 0 : 100
		brightness = @step < 1 ? 0 : 100 # canyon
		[tuned_hue.to_i, 100, brightness]
	end
end

CORES = 8.freeze

def setup
	size displayWidth, displayHeight
	colorMode(HSB,360,100,100)
	frame_rate 10
	background 0
  load_pixels

  CORES.times do |i| 
  	Thread.new { calculate i }
  end
end

def calculate t
	m = Collatz.new(width, height)

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
