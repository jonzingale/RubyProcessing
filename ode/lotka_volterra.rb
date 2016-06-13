# an attempt to see the bigger picture.
	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		stroke(210,100,100,100)
		@w, @h = width, height
		stroke_width 1
    frame_rate 20
		background(0)

		@pts = points 3000
		@del_t = 0.003
	end

	def points num
		(1..num).map { [20*rand, 10*rand, rand(80)] }
	end

	def diff(x,y,z)
		# lotka-volterra
		a,b,c,d = [6, 2, 10, 2]
		[a*x - b*x*y, -c*y + d*x*y, 1]

		# with harvesting
		# a, b, h = 0.005, 6, -2
		# [x*(1-a*x-y), y*(b-x-y)+h, 1]
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

	Xu, Yu = 100, 100

	def draw
		euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z, 100, 100, 20
			line Xu*x, Yu*y, Xu*s, Yu*t
		end

		@pts = @next_pts
	end