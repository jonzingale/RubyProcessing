	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
    frame_rate 5

		background(0)
		stroke(200,0,100,100)
		stroke_width 0.1
		@pts = points 12000
		@del_t = 0.002
	end

	def points num
		(1..num).map do
			[(rand(width)-@w)/1.0,
			 (rand(height)-@h)/1.0,
			 rand(360)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		x = x % 2 < 0.5 ? y*2 : -x*3
		[abs(z) < 100 ? (x+1) : y + 100 * Math.sin(y),
		 x % 3 < 1.3 ? x : -x**2 % 100 > 55 ? x*2 : -y*4,
		 x-y % 360]
	end

	def euler
		@next_pts = @pts.map do |x, y, z|
			s, t, r = diff x, y, z
			dx = x + s * @del_t
			dy = y + t * @del_t
			dz = z + r * @del_t
			[dx, dy, dz]
		end
	end

	def improved_euler
		@next_pts = @pts.map do |x, y,z|
			s, t, r = diff x, y, z
			dx = x + s * @del_t
			dy = y + t * @del_t
			dz = z + r * @del_t

			s, t, r = diff dx, dy, dz
			ddx = dx + s * @del_t
			ddy = dy + t * @del_t
			ddz = dz + r * @del_t

			[(dx + ddx) /2.0, (dy + ddy) /2.0,  (dz + ddz) /2.0]
		end
	end

	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke r, 70, 100, 100

			# line x+@w, y+@h, s+@w, t+@h
			line (x+@w)/1.0, (y+@h)/1.0, (s+@w)/1.0, (t+@h)/1.0
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [rand(width)-@w,rand(height)-@h]
		end
	end