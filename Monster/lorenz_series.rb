require (File.expand_path('./monster', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app

		# what is the limit here.
		# better would be to calculate all lorenz paths in one ary
		# inside a collection of monsters.
	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 120
		background(0)
		no_stroke

		@monsters = create_monsters 10
	end

	def create_monsters num
		(1..num).map do |i|
			 # x_coord, y_coord, legs=4, thickness=40, input_dyn=nil
			Monster.new(width/i, @h, 5, 10)
		end
	end

	def render_lorenz monster
		monster.beziers.each do |bezier|
			pts = bezier.points[0]
			color = monster.color[0,3]+[40]
			fill(*color) ; ellipse(*pts,1,1)
		end
	end

	def render monster
		monster.beziers.each do |bezier|
			(0..RES).each do |q|
				pt = bezier.plot(q / RES)
				qt = bezier.plot((q+1) / RES)
				stroke_width(monster.thickness)
				hue, sat, bri, opa = monster.color
				color = [hue+rand(100), sat+rand(50), bri, opa]
				stroke(*color) ; line(*pt,*qt)
			end
		end
	end

	def draw #; clear
		@monsters.map do |monster| 
			monster.dynamics
			# render monster
			render_lorenz monster
		end
	end