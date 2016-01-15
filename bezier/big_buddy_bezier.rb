require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./lorenz', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app

	# create a field of these guys, with perspective.
	# better colors? snow?

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 50
		background(0)

		@monster = Monster.new 2, width, height
		@attractor = Lorenz.new
		# stroke_width(120)
		stroke_width(200)
		# stroke_width(15)
	end

	def dynamics
		@attractor.blink
		x = @attractor.x * 40 + @w/1.2
		y = @attractor.y * 20 + @h/1.3
		@monster.beziers.map{|bezier| bezier.coords([x,y])}
	end

	def draw
		clear ; dynamics
		(0..RES).each do |q|
			@monster.beziers.each do |bezier|
				pt = bezier.plot(q/RES)
				qt = bezier.plot((q+1)/RES)
				color = [200+rand(100), 30+rand(50), 80, 100]
				stroke(*color) ; line(*pt,*qt)
			end
		end
	end

	class Monster
		attr_reader :beziers, :color
		def initialize num, width, height
			@beziers = (1..num).map do |i|
				# points = [[0,height], [width/2,rand(10)], [i * width/3/num, height/2]]
				points = [[0,height], [width/2,rand(10)], [i * rand(width), height/2]]

				Bezier.new(points)
			end
		end
	end

	# class Monster
	# 	attr_reader :beziers, :color
	# 	def initialize num, width, height
	# 		@beziers = (1..num).map do |i|
	# 			points = [[0,height], [width/2,rand(10)], [i * width/num, height]]
	# 			Bezier.new(points)
	# 		end
	# 	end
	# end