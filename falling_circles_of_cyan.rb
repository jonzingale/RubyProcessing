# The goal here is to make falling
# cyan circles

	def setup
		grid = 860 ; size(grid,grid)
		@w, @h = [grid/2.0, 0]
		@i = 0 ; @t = 0

    frame_rate 30

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

	  no_fill
	  stroke(200,100,100)
	  stroke_weight(5)

	  @coords = (0..30).map{ [rand(2000),
	  												rand(2000),
	  												0,
	  												0,
	  												180 + rand(60),# hue
	  												rand(10) + 90, # sat
	  												# 100,
	  												rand(10) + 90, # bright
	  												# 100
	  												rand(15) + 85   # opacity
	  												] }
	end

	def trip_x(t) ; rand(20) == 1 ? (-1) ** rand(2) : t ; end
	def trip_y(s) ; rand(3) == 1 ? rand(2) : s ; end

	def draw
		clear

		@coords.map! do |x, y, s, t, hue, sat, bri, opac|
			x, y, s, t = [x + trip_x(t) * 3, 
										y + trip_y(s) * 2, 
										s, 
										t
										].map{|i| i % width}

			stroke(hue,sat,bri,opac)
			ellipse(x,y, 100, 100)
			[x,y,s,t,hue,sat,bri,opac]
		end
	end
