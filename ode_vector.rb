	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
    frame_rate 10

		background(0)
		stroke(200,100,100,100)
		stroke_width 1
		@pts = points 1700
		@del_t = 0.01
	end

	def points num
		(1..num).map {[rand(width)-@w ,rand(height)-@h]}
	end

	def diff(x,y)
		[-y,-x+y]
	end

	def euler
		@next_pts = @pts.map do |x, y|
			s, t = diff x, y
			dx = x + s * @del_t
			dy = y + t * @del_t
			[dx, dy]
		end
	end

	def improved_euler
		@next_pts = @pts.map do |x, y|
			s, t = diff x, y
			dx = x + s * @del_t
			dy = y + t * @del_t

			s, t = diff dx, dy
			ddx = dx + s * @del_t
			ddy = dy + t * @del_t

			[(dx + ddx) /2.0, (dy + ddy) /2.0]
		end
	end

	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y),(s,t)|
			stroke rand(360), 30, 100, 50
			line x+@w, y+@h, s+@w, t+@h
		end

		@pts = @next_pts.map do |x,y|
			[x,y]
			# [rand(width)-@w,rand(height)-@h]
		end
	end