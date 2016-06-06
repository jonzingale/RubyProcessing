	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 15

		background(0)
		stroke(210,100,100,10)
		stroke_width 1
		@pts = points 12000
		@del_t = 0.03
	end

	PI = 3.1415926
	def points num
		(1..num).map do

			[6 * ((rand * 2 * PI)- PI),
			 3 * rand * PI, # HALF
			 # 2 * ((rand * 2 * PI)- PI), # FULL
			 rand(300)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# nonlinear oscillator
		# b = 1 ; [	y, -b*y - Math.sin(x), z]

		# a,b,c,d = 1,2,1,1
		# x = a*x-b*x*y
		# y = -c*y+d*x*y

		# harvested volterra-lotka
		# a, b, h = 1, 1, 0
		# x = x*(1-a*x-y)
		# y = y*(b-x-y+h)

		# van der pol
		x = y - x**3 + x
		y = -x

		# x = Math.sin(x)*(-0.1*Math.cos(x)-Math.cos(y))
		# y = Math.sin(y)*(Math.cos(x)-0.1*Math.cos(y))
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

	MU = 100
	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			# stroke 200+r, 100, 100, 100

			line ((x+@w)*MU-@w*MU+@w+360)/2.5, ((y+@h)*MU-@h*MU/1.01)/1.0,
					 ((s+@w)*MU-@w*MU+@w+360)/2.5, ((t+@h)*MU-@h*MU/1.01)/1.0
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [rand(width)-@w,rand(height)-@h,z]
		end
	end