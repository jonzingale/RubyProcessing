	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 5

		background(0)
		stroke(200,0,100,80)
		stroke_width 0.1
		@pts = points 12000
		@del_t = 0.02
	end

	PI = 3.1415926
	def points num
		(1..num).map do

			[6*((rand * 2 * PI)- PI),
			 6*((rand * 2 * PI)- PI),
			 rand(360)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# [-y,-x+y, x+y % 360]
		# [-y,x, x % 360]
		# [y-x, -x, z]

		# nonlinear oscillator
		b=1 ; [y, -b*y-Math.sin(x),z]
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

	MU = 100
	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke r, 70, 100, 100
			line (x+@w)*MU-@w*MU, (y+@h)*MU-@h*MU/1.01,
					 (s+@w)*MU-@w*MU, (t+@h)*MU-@h*MU/1.01
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [rand(width)-@w,rand(height)-@h,z]
		end
	end