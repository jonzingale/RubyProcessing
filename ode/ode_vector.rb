	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = width/2, height/2
    frame_rate 10 ; background 0
		stroke_width 0.3
		@pts = points 12000
		@del_t = 0.002
	end

	def points num
		(1..num).map { [1*rand,6*rand,rand] }
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		q = x % (rand(30)+1) < 4 ? y*2 :  y/2.0
		r = y % 3 < 2.5 ? 10*Math.sin(x**2) + z : -Math.cos(x) + z
		s = x % 2 < 1.5 ? x*3+1 : y/2

		[q, r, s]
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

	Xu, Yu = 200, 100

	def draw
		improved_euler
		# clear
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z*100%360, z*100, 100, 80
			# line Xu*x, Yu*z, Xu*s, Yu*r
			line Xu*x, Yu*y, Xu*s, Yu*t
		end

		@pts = @next_pts
	end