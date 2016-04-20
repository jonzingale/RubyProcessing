class Collatz
	PI = 3.1415926.freeze
	Escape = 10**3.freeze
	Limit = 255.freeze

	def initialize(width, height)
		@width, @height = width.to_f, height.to_f
		@scale = [20, 20].map{|t| t * 0.1**1 } # zoom
	end

	def to_complex x, y
		s, r = @scale
		x = s * x / @width - s/2.0
		y = r/2.0 - r * y / @height
		z = Complex(x,y)
	end

	def collatz
		# trig = @z.rect.map{|t| Math.cos(PI*t)}
		# 0.25*(1+4*@z-(1+2*@z)*Complex(*trig)) # this with *
		@z.abs.round.even? ? @z/2 : @z*3+1
	end

	def produce
		while @z.abs < Escape && @step < Limit
			@z = collatz + @point
			@step += 1
		end
	end

	def get_color(w, h)
		@point = to_complex w, h
		@z, @step = 0, 0
		produce ; set_color
	end

	def set_color
		# tuned_hue = Math.log(@step) * 70 - 70 # rising sun
		tuned_hue = Math.log(@step) * 70 + 70 # ocean
		# tuned_hue = Math.log(@step) * 70 - 90 # miami vice
		# tuned_hue = Math.log(@step) * 70 - 10 # wicked 3d glasses

		# brightness = @step < 4 ? 0 : 100
		brightness = @step < 4 ? 0 : 100
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
