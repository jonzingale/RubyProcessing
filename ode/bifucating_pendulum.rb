	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 10

		background(0)
		stroke(210,100,100,100)
		stroke_width 1
		@pts = points 9000
		@del_t = 0.03
	end

	PI = 3.1415926
	def points num
		(1..num).map do

			[6 * ((rand * 2 * PI)- PI),
			 3 * rand * PI, # HALF
			 # 2 * ((rand * 2 * PI)- PI), # FULL
			 rand(100)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# nonlinear oscillator
		# b = 1 ; [	y, -b*y - Math.sin(x), z]

		# b= 3 ; k=Math.cos(x*y) # x, y, z all good!
		# [y, -x*k -b*y + PI*Math.sin(y), 1]

		# pendulum
		# b = 0 ; [y, -Math.sin(x),1]

		# huygens clocks 
		# b = 2 ; k = 1 # x, y, z all good!
		# [y, -x*k -b*y + 6*Math.cos(z), 1]

		# split up
		b = 1 ; k = 1.2*Math.cos(x) # x, y, z all good!
		[y, -x*k -b*y + PI*Math.sin(y), 1]
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
		clear
		improved_euler
		@pts.zip(@next_pts).each do |(x,y,z),(s,t,r)|
			stroke 200+r, 100, 100, 100

			line ((x+@w)*MU-@w*MU+@w*2)/2.5, ((y+@h)*MU-@h*MU/1.01)/1.0,
					 ((s+@w)*MU-@w*MU+@w*2)/2.5, ((t+@h)*MU-@h*MU/1.01)/1.0
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [rand(width)-@w,rand(height)-@h,z]
		end
	end