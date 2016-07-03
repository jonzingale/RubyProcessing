# SIR models
	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		stroke(210,100,100,100)
		@w, @h = width, height
		stroke_width 2
    frame_rate 15
		background(0)

		@pts = points 3000
		@del_t = 0.003
	end

	def points num
		(1..num).map { [rand, rand, rand] }
	end

	def diff(x,y,z)
		# SIR
		b, v, u = 2, 3, 1

		# original
		s = -b*x*y + u*z
		i =  b*x*y - v*y
		r =  v*y*z - u*z

		# elaborate
		# s = -b*x*y + 0*y*z + u*z*x
		# i =  b*x*y - v*y*z + 0*z*x
		# r =  0*x*y + v*y*z - u*z*x

		# test
		# s = -b*x*y
		# i = b*x*y + v*z*y
		# r = -v*z*y

		[s,i,r]
	end

	def euler
		@next_pts = @pts.map do |x,y,z|
			s, t, r = diff x, y, z
			dx = x + s * @del_t
			dy = y + t * @del_t
			dz = z + r * @del_t

			s, t, r = diff dx, dy, dz
			ddx = dx + s * @del_t
			ddy = dy + t * @del_t
			ddz = dz + r * @del_t

			[(dx + ddx) /2.0, 
			 (dy + ddy) /2.0,
			 (dz + ddz) /2.0]
		end
	end

	Xu, Yu = 1900, 1000

	def draw
		euler
		# clear
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z*100, 100, 100, 80
			# line Xu*x, Yu*z, Xu*s, Yu*r
			line Xu*x, Yu*y, Xu*s, Yu*t
		end

		@pts = @next_pts
	end