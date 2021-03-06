class Mandelbrot
	Escape = 10**30.freeze
	Limit = 255.freeze
	PHI = (1+5**0.5)/2.0
	PHA = (1-5**0.5)/2.0
	C = 5**-0.5

	def initialize(width, height)
		@width, @height = width.to_f, height.to_f
		@scale = [4, 2.3].map{|t| t * 0.1**1 } # <-- smaller to zoom
	end

	def to_complex x, y
		s, r = @scale
		x = s * x / @width - s/2.0
		y = r/2.0 - r * y / @height
		z = Complex(x,y)
	end

	# def fibs(n) ; C * (PHI**n - PHA**n) ; end
	def fibs(n) ; PHI**n - PHA**n ; end

	def produce
		while @z.abs < Escape && @step < Limit
			@z = fibs(@z) + @point
			@step += 1
		end
	end

	def get_color(w, h)
		@point = to_complex w, h
		@z, @step = 0, 0
		produce ; set_color
	end

	def set_color
		tuned_hue = Math.log(@step) * 70 - 90 # miami vice
		# tuned_hue = Math.log(@step) * 70 - 170 # rising sun
		# tuned_hue = Math.log(@step) * 70 - 10 # wicked 3d glasses

		brightness = @step < 15 ? 0 : 100
		[tuned_hue.to_i, 100, brightness]
	end
end

CORES = 8.freeze

def setup
	size displayWidth/2, displayHeight/2
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
