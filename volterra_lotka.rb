	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2]
    frame_rate 15

		background(0)
		stroke(210,100,100,10)
		stroke_width 1
		@pts = points 12000
		@del_t = 0.0007
	end

	def points num
		(1..num).map do
			[rand * 9,-rand * 4, rand(100)]
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
		a, b, h = [0.5] * 3
		x = x*(1-a*x-y)
		y = y*(b-x-y)+h

		[x,y,z]
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
		@next_pts = @pts.map do |x,y,z|
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

	MU = 200
	def draw
		# fill 0,0,0,1
		# rect(0,0,width,height)

		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			# stroke 210, 100+z, 100, 20
			# line(MU*x,MU*y,MU*s/1.01,MU*t/1.01)

			line MU*x, ((y+@h)*MU-(@h+1)*MU/1.01),
					 MU*s, ((t+@h)*MU-(@h+1)*MU/1.01)

			# line(x+@w,y+@w,s+@h,t+@h)
		end

		@pts = @next_pts
	end