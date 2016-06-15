	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 20

		background(0)
		stroke(210,100,100,30)
		stroke_width 1
		@pts = points 6000
		@del_t = 0.0007
	end

	PI = 3.1415926
	def points num
		(1..num).map do
			[2 * ((rand * 2 * PI)- PI),
			 2 * ((rand * 2 * PI)- PI),
			 rand(100)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# van der pol
		# [ y - x**3 + x, -x , x]

		[ y**2 - x**3 * Math.sin(x), -x , 1]
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

	MU = 100
	def draw
		# fill 0,0,0,1
		# rect(0,0,width,height)

		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke z, 100, 100, 20
			line ((x+@w)*MU-@w*MU+@w), ((y+@h)*MU-@h*MU/1.01),
					 ((s+@w)*MU-@w*MU+@w), ((t+@h)*MU-@h*MU/1.01)
		end

		@pts = @next_pts
	end