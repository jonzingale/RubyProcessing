require (File.expand_path('./bezier', File.dirname(__FILE__)))

	RES = 40.0.freeze
	
	def setup
		# size(displayWidth/2.3, displayHeight/1.3)
		size(displayWidth, displayHeight/1.1)

		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20

		colorMode(HSB,360,100,100,60)
	  text_font create_font("SanSerif",30)
		background(0)

		points = [[0,height],[@w,0],[@w,height]]
		@bezier = Bezier.new(points)
		stroke_width(100)
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		points = [coords,[@w,0],[@w,height]]
		@bezier = Bezier.new(points)
	end

	def draw
		clear

		(0..RES).each do |q|
			pt = @bezier.plot(q/RES)
			qt = @bezier.plot((q+1)/RES)
			color = [200+rand(100),50+rand(50),100]
			stroke(*color) ; line(*pt,*qt)
		end

	end
