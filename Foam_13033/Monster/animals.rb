require (File.expand_path('./monster', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 12
		background(0)

		@monsters = create_monsters 3 # three animals
	end

	def create_monsters num
		(1..num).map do
			 # x_coord, y_coord, feet_num=4, thickness=40, input_dyn=nil
			Monster.new(rand(width+200), rand(height+100), 3, rand(10)) # thin threads
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
			render monster
		end
	end