require (File.expand_path('./bezier', File.dirname(__FILE__)))

	RES = 40.0.freeze
	
	def setup
		size(displayWidth, displayHeight/1.1)

		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20

		colorMode(HSB,360,100,100,60)
	  text_font create_font("SanSerif",30)
		background(0)

		points = [[0,height],[@w,0],[@w,height]]
		@bezier = Bezier.new(points)

		points = [[rand(100),height],[@w,0],[rand(100),height]]
		@grezier = Bezier.new(points)
		stroke_width(400)
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		@bezier.coords(coords)
		@grezier.coords(coords)
	end

	def draw
		clear

		(0..RES).each do |q|
			pt = @grezier.plot(q/RES)
			qt = @grezier.plot((q+1)/RES)
			color = [200+rand(100),50+rand(50),100]
			stroke(*color) ; line(*pt,*qt)



			pt = @bezier.plot(q/RES)
			qt = @bezier.plot((q+1)/RES)
			color = [200+rand(100),50+rand(50),100]
			stroke(*color) ; line(*pt,*qt)
		end

	end
