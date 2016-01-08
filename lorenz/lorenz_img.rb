# require (File.expand_path('./lorenz', File.dirname(__FILE__)))
	# binding = $app
	def setup
		size(displayWidth, displayHeight)
		text_font create_font("SanSerif",50)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
		no_stroke
		background(0)
    frame_rate 100

		@attractor = Lorenz.new
		@bttractor = Lorenz.new
	end

	def plot_lorenz(attractor)
		x = attractor.x * 20 + @w
		y = attractor.y * 20 + @h
		c = attractor.color
		fill(*c) ; ellipse(x,y,10,10)
		attractor.blink
	end

	def draw
		plot_lorenz(@attractor)
		plot_lorenz(@bttractor)
	end