require (File.expand_path('./monster', File.dirname(__FILE__)))
	RES = 40.0.freeze

	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0 ; background(0)
    frame_rate 20

		@monsters = create_monsters 3
	end

	def create_monsters num # legs, thickness
		# (1..num).map{|i| Monster.new(@w, @h, 5, 15)}
		(1..num).map{|i| Monster.new(rand(width), @h+100+rand(300), 5, 45)}
	end

	def render_dynamics monster
		lorenz = monster.attractor
		x, y, z = monster.coords.map{|t| t*15}

		pair = x + @w, y + @h
		hue, sat, bri, opa = monster.color

		color = [lorenz.dz+50, 
						 lorenz.dx/2 + 70,
						 lorenz.dy/4 + 90, 100]

		stroke_width(30) ; stroke(*color) ; point(*pair)
	end

	def render_monster giraffe
		# body
		# x, y, z = giraffe.dynamics.map{|t| t*15}
		x, y, z = giraffe.coords.map{|t| t*15}
		giraffe.beziers.map{|bezier| bezier.coords([x+@w,y+@h])}

		giraffe.beziers.each do |bezier|
			(0..RES).each do |q|
				# line(pt, qt)
				pt = bezier.plot(q / RES)
				qt = bezier.plot((q+1) / RES)

				stroke_width(giraffe.thickness)
				hue, sat, bri, opa = giraffe.color
				color = [hue+rand(100), sat, bri, opa]
				stroke(*color) ; line(*pt, *qt)
			end

			# head
			pts = bezier.points[0]
			color = giraffe.color[0,3]+[50]
			fill(*color) ; ellipse(*pts,30,30)
		end
	end

	def draw ; clear
		@monsters.map do |giraffe| 
			giraffe.dynamics
			render_monster giraffe
			render_dynamics giraffe
		end


		# text("X",@w,@h)
	end