	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
		@i, @j = 1,1 ; @t = 0
    frame_rate 10

		background(0)
		stroke(200,100,100,100)
		stroke_width(10)
		@pts = points 2000
		@del_t = 0.3
	end

	def points num
		(0...num).map do
			[rand(width)-@w, rand(height)-@h]
		end
	end

	def epsilon?(pt)
		dt  = pt.map{|t| diff(t) ** 2}.inject(0,:+)
		ddt = pt.map{|t| diff(diff(t)) ** 2}.inject(0,:+)
		ddt - dt < 0.0
	end

	def diff t
		# (x**3 - 4 * x**2 + 7 * x)
		Math.cos(t**2+1) - t
		# 100 * Math.sin(Math.sin(3-x**2)	)
	end

	def euler
		@next_pts = @pts.map do |x,y|
			x, y = x + diff(x) * @del_t, y + diff(y) * @del_t
		end
	end

	def mouseMoved ; @i, @j = [mouseX,mouseY] ; end
	def text_block(string='')
		fill(0,0,0)
		rect(90,80,200,40)
		fill(200, 140, 100)
		text(string,100,100)
	end

	def draw
		clear
		euler
		@pts.zip(@next_pts).each do |(x,y),(s,t)|
			stroke rand(360), 100, 100, 20
			line x+@w, y+@h, s+@w, t+@h
		end

		@pts = @next_pts.map do |x,y|
			if epsilon?([x,y])
				[rand(width)-@w,rand(height)-@h]
			else
				[diff(x), diff(y)]
			end
		end

	end