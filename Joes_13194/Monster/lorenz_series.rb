require (File.expand_path('./monster', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app

	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 200
		background(0)
		no_stroke

		@monsters = create_monsters 10
	end

	def create_monsters num
		(1..num).map do |i|
			Monster.new(width/i, @h, 5, 10)
		end
	end

	def render_lorenz monster
		monster.beziers.each do |bezier|
			x, y = bezier.points[0]
			color = monster.color[0,3]+[50]

			pts = [x*1.4-300, y*3 - 400]

			fill(*color) ; ellipse(*pts,1,1)
		end
	end

	def draw #; clear
		@monsters.map do |monster| 
			monster.dynamics
			render_lorenz monster
		end
	end