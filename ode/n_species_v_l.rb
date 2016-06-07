	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
    frame_rate 10

		background(0)
		stroke(210,100,100,100)
		stroke_width 0.3
		@pts = points 9000
		@del_t = 0.007
	end

	def points num
		(1..num).map do
			[rand * 2, 1 * rand * (-1)**rand(2), rand(100)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# volterra-lotka
		# a,b,c,d = [2/3.0,4/3.0,1,1]
		# a,b,c,d = [0.1,0.4,1,1]
		# x = a*x - b*x*y
		# y = d*x*y - c*y

		# harvested Volterra-Lotka
		a,b,c,h = 5, 5, 1.7, 10
		x = x*(1-a*y*z)
		z = z*(1-c*z*y)
		y = y*(b-x*z)+h
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

	Xu, Yu = 1500, 60

	def draw
		euler
		# fill(0,0,0,10) ; rect(0,0,width,height)
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke 210, 100, 100, 80
			if y**2+t**2 < 1500
				line Xu*x+40, Yu*z+@h, Xu*s+40, Yu*r+@h
				# line Xu*x+40, Yu*y+@h, Xu*s+40, Yu*t+@h
			end
		end

		@pts = @next_pts
	end