	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
    frame_rate 20

		background(0)
		stroke(200,0,100,30)
		stroke_width 0.1
		@pts = points 12000
		@del_t = 0.009
		# @del_t = 1
	end

	def points num
		(1..num).map do
			# [(rand(width)-@w)/10.0 ,(rand(height)-@h)/400.0]
			[(rand(width)-@w)/5.0 ,(rand(height)-@h)/2.0]

		end
	end

	def diff(x,y)
		# [-y,-x+y]
		# [-y,x]
		# [y-x, -x]
		# [x % 2 < 1 ? x*1.3 : -y, x]
		[x % 2 < 0.5 ? x+y*3 : -y, x - y]
		# [x % 2 < 0.5 ? x+1+y*3 : 2-y, y % 3 < 0.5 ? 3*(y+1.5) : - x]
		# it = [y % 3 < 0.5 ? 3*(y+1.5) : - x, x % 2 < 0.5 ? x+2+y*3 : 2-y]
		# it[1] % 5 < 4.8 ? it.reverse : it
 		# [x/2, 3]
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
			# stroke rand(360), 70, 100, 50

			# line x+@w, y+@h, s+@w, t+@h
			line (x+@w)/1.0, (y+@h)/1.0, (s+@w)/1.0, (t+@h)/1.0

		end

		@pts = @next_pts.map do |x,y|
			[x,y]
			# [rand(width)-@w,rand(height)-@h]
		end
	end