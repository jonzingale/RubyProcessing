	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
    frame_rate 10

		background(0)
		stroke(210,100,100,100)
		stroke_width 0.9
		# stroke_width 10
		@pts = points 3000
		@del_t = 0.03
		@cds = 0, 0
	end

	def points num
		(1..num).map do
			[rand, rand, rand(210)]
		end
	end

	def diff(x,y,z)
		# volterra-lotka
		# a,b,c,d = [1, 2, # prey: birth/death
							 # 0.5, 5] # predator : death/birth
		# x = a*x - b*x*y
		# y = d*x*y - c*y

		# limited growth
		# a, b, c, d, lam, mu = [1.4, -0.5, -0.5, 2, 4, 1]
		# x = x * (a - b*y - lam * x)
		# y = y * (-c + d*x - mu * y)

		# with harvesting
		a,b,h = 2, 0.5, 0.1
		x = x*(1-a*x-y)
		y = y*(b-x-y)+h
		z = -0.3*z
		# z = abs(y*x)
		[x,y,z]
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

	Xu, Yu = 1900, 1200

	def draw
		euler
		# fill(0,0,0,10) ; rect(0,0,width,height)
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z/3, 100, 100, 90
			line Xu*x, Yu*y, Xu*s, Yu*t
		end

		# no_fill ; ellipse(10,10,10,10)

		@pts = @next_pts
	end