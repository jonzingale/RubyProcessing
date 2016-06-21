	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = width/2.0, height/2.0
    frame_rate 10 ; background 0
		stroke_width 1
		@pts = points 12000
		@del_t = 0.002
	end

	def cent_rand
		20 * (rand - 1 * rand)
	end

	def points num
		(1..num).map { [cent_rand, cent_rand, cent_rand]}
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# q = x % 5 < 4 ? y*x : x
		# r = y % 3 < 1.5 ? x : -x
		# s = x**2 % 2 < 1.5 ? y*z : -y/z

		q = y
		r = -x + 2*Math.sin(y)
		s = Math.tan(r)

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

	Xu, Yu = 30, 30

	def draw
		improved_euler
		clear
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z*10%360, 100, 100, 180*z
			line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts
	end