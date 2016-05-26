	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
		@i, @j = 1,1 ; @t = 0
    frame_rate 10

		background(0)
		stroke(200,100,100,100)
		stroke_width 10
		@pts = points 1000
		@del_t = 0.3
	end

	def points num
		(0...num).map do
			[rand(width)-@w, rand(height)-@h]
		end
	end

	def diff t
		# t = t.to_i
		# t.even? ? t/2 : t*3-1

		# Math.cos(t**2+1) + t
		2-Math.exp(-4*@del_t)-2*t
		# Math.tan(t)
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

	def mouseMoved
		@i, @j = [mouseX,mouseY]
	end


	def draw
		clear
		euler
		# improved_euler
		@pts.zip(@next_pts).map! do |(x,y),(s,t)|
			stroke rand(360), 100, 100, 20
			line x+@w, y+@h, s+@w, t+@h
			[rand(width)-@w,rand(height)-@h]
		end

	end