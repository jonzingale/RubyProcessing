require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./glowbug', File.dirname(__FILE__)))

	RES = 48.0.freeze
	def setup
		# size(displayWidth/2.3, displayHeight/1.3)
		size(displayWidth, displayHeight/1.1)

		@w, @h = [width/2.0, 0]
    frame_rate 48

		colorMode(HSB,360,100,100,60)
	  text_font create_font("SanSerif",30)

		@bugs = (0..12).map do
			bug_pts = [rand(width),rand(height)]
			Glowbug.new(bug_pts)
		end

		points = [[0,height],[@w,0],[@w,height]]
		@bezier = Bezier.new(points)
		stroke_width 100
	end


	def bugs # fireflies for the worm to follow?
		@bugs.each do |bug|
			colors = [80+rand(100),10+rand(10),100,50]
			bug_pts = bug.walk(width,height)
			rand_size = [rand(10)] * 2
			fill(*colors)
	
			ellipse(*bug_pts,*rand_size)
		end
	end

	def worm
		(0..RES).each do |q|
			pt = @bezier.plot(q/RES)
			qt = @bezier.plot((q+1)/RES)
			color = [200+rand(100),50+rand(50),100]
			stroke(*color) ; line(*pt,*qt)
		end
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		points = [coords,[@w,0],[@w,height]]
		@bezier = Bezier.new(points)
	end

	def draw
		# clear
		
		fill(0,0,0,20) # trails
		rect(-60,-60,width+120,height+120)

		bugs ; worm
	end
