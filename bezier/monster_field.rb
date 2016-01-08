require (File.expand_path('./bezier', File.dirname(__FILE__)))
	RES = 40.0.freeze
	# binding = $app
	# perhaps following a lorenz?

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20
		background(0)

		@monster = Monster.new 7, width, height
		stroke_width(160)
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		@monster.beziers.map{|bezier| bezier.coords(coords)}
	end

	def draw ; clear
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
			@beziers = (1...num).map do |i|
				# points = [[0,height], [width/2,rand(3000)], [i * width/num, height]]
				points = [[0,height], [width/2,rand(30)], [i * width/num, height]]
				Bezier.new(points)
			end
		end
	end