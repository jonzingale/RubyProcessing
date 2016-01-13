require (File.expand_path('./poisson_process', File.dirname(__FILE__)))
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
    frame_rate 20

    @flakes = create_flakes 2300
		@monsters = create_monsters 1
	end

	def create_monsters num # 		legs, thickness
		(1..num).map{|i| Monster.new(@w, @h, 5, 15)}
	end

	def create_flakes num, density=3
		components, snow = Poisson.new(num, density).components, []

		components.each_with_index do |n, size|
			n.times{ snow << Snow.new(width, height, size+1) }
		end ; snow
	end

	def render_flake flake
		x, y, *zs = flake.coords
		ellipse(x, y, flake.size, flake.size)
	end

	SCALAR = 0.3 # see here
	def render monster
		# body
		monster.beziers.each do |bezier|
			(0..RES).each do |q|
				# line(pt, qt)
				pt = bezier.plot(q / RES).map{|t| t*SCALAR + 550}
				qt = bezier.plot((q+1) / RES).map{|t| t*SCALAR + 550}

				stroke_width(monster.thickness)
				hue, sat, bri, opa = monster.color
				color = [hue+rand(100), sat+rand(50), bri, opa]
				stroke(*color) ; line(*pt, *qt)
			end

			# head
			pts = bezier.points[0].map{|t| t*SCALAR + 550}
			color = monster.color[0,3]+[50]
			fill(*color) ; ellipse(*pts,30*SCALAR,30*SCALAR)
		end
	end

	def draw ;  clear
		# snow bank
		fill(0,0,100,50)
		rect(0,height-380,width,height)

		@monsters.map do |monster| 
			monster.dynamics
			render monster
		end

		no_stroke
		@flakes.map do |flake|
			fill(0,0,100,20+6*flake.size)
			flake.drift
			render_flake flake
		end
	end