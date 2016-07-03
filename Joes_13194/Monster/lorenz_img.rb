require (File.expand_path('./lorenz', File.dirname(__FILE__)))
	# binding = $app
	def setup
		size(displayWidth/2, displayHeight/1.3)
		text_font create_font("SanSerif",50)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
		background(0)
    frame_rate 100
		no_stroke

		@trajectories = get_trajectories(30)
	end

	def get_trajectories num
		(0...num).map{ Lorenz.new }
	end

	def plot_lorenz(attractor)
		x = attractor.x * 15 + @w + rand(0)
		y = attractor.y * 15 + @h
		c = attractor.color
		fill(*c) ; ellipse(x,y,6,6)
		attractor.blink
	end

	def draw
		@trajectories.each{|t| plot_lorenz t}
	end