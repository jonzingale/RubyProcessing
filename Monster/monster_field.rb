require (File.expand_path('./monster', File.dirname(__FILE__)))
require (File.expand_path('./snow', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app

	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0 ; background(0)
    frame_rate 30

    @flakes = create_flakes 2300
		@monsters = create_monsters 1
	end

	# SHOULD monsters carry their own coordinates
	# so that translations are less awkward.
	def create_monsters num
		(1..num).map do |i|
			Monster.new(@w, @h, 5, 15) # legs, thickness
		end
	end

	def create_flakes num
		(1..num).map{ Snow.new(width, height) }
	end

	def render_flake flake
		x, y, *zs = flake.coords
		ellipse(x, y, flake.size, flake.size)
	end

	def translate p, q
		[p + 600, q + 300]
	end

	def scale p, q
		[p * SCALAR, q * SCALAR]
	end

	SCALAR = 0.3
	def render monster
		# body
		monster.beziers.each do |bezier|
			(0..RES).each do |q|
				# line(pt, qt)
				pt = bezier.plot(q / RES).map{|t| t*SCALAR}
				pt = translate(*pt)

				qt = bezier.plot((q+1) / RES).map{|t| t*SCALAR}
				qt = translate(*qt)

				stroke_width(monster.thickness)
				hue, sat, bri, opa = monster.color
				color = [hue+rand(100), sat+rand(50), bri, opa]
				# color = monster.color

				stroke(*color) ; line(*pt,*qt)
			end

			# head
			pts = bezier.points[0].map{|t| t*SCALAR}
			pts = translate(*pts)

			color = monster.color[0,3]+[50]
			fill(*color) ; ellipse(*pts,30*SCALAR,30*SCALAR)
		end
	end

	def draw ;  clear
		fill(0,0,100,50)
		rect(0,@h-60,width,height)

		@monsters.map do |monster| 
			monster.dynamics
			render monster
		end

		no_stroke ; fill(0,0,100,40)
		@flakes.map do |flake|
			flake.drift
			render_flake flake
		end
	end