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
    frame_rate 10

    @flakes = create_flakes 3000
		@monsters = create_monsters 1
		@pts = points 1000
		@del_t = 0.2
	end

	def create_monsters num # 		legs, thickness
		(1..num).map{|i| Monster.new(@w, @h, 5, 150)}
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

	SCALAR = 1.3
	TRANSLATE = -70
	def render monster
		# body
		monster.beziers.each do |bezier|
			(0..RES).each do |q|
				# line(pt, qt)
				pt = bezier.plot(q / RES).map{|t| t*SCALAR + TRANSLATE}
				qt = bezier.plot((q+1) / RES).map{|t| t*SCALAR + TRANSLATE}

				stroke_width(monster.thickness)
				hue, sat, bri, opa = monster.color
				color = [hue+rand(100), sat+rand(50), bri, opa]
				stroke(*color) ; line(*pt, *qt)
			end

			# head
			pts = bezier.points[0].map{|t| t*SCALAR + TRANSLATE - 2}
			color = monster.color[0,3]+[50]
			fill(*color) ; ellipse(*pts,30*SCALAR,30*SCALAR)
		end
	end

	def draw ; clear
		# rainbows
		euler ; stroke_width(5)
		@pts.zip(@next_pts).map! do |(x,y),(s,t)|
			stroke rand(360), 100, 100, 8
			line x+@w, y+@h, s+@w, t+@h
			[rand(width)-@w,rand(height)-@h]
		end

		# snow bank
		fill(0,0,100,100) ; no_stroke
		rect(0,height-380,width,height)

		# monsters
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

	def points num
		(0...num).map do
			[rand(width)-@w, rand(height)-@h]
		end
	end

	def diff t
		2-Math.exp(-4*@del_t)-2*t
	end

	def euler
		@next_pts = @pts.map do |x,y|
			x, y = x + diff(x) * @del_t, y + diff(y) * @del_t
		end
	end

	def improved_euler
		@next_pts = @pts.map do |x,y|
			dx = x + diff(x) * @del_t
			dy = y + diff(y) * @del_t

			ddx = dx + diff(dx) * @del_t
			ddy = dy + diff(dy) * @del_t

			[(dx + ddx) /2.0, (dy + ddy) /2.0]
		end
	end

