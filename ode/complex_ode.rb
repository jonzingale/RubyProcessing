require 'matrix'
require 'cmath'
include CMath
include Math

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 10

		background(0)
		stroke(210,100,100,100)
		stroke_width 1
		@pts = points 2000
		@del_t = 0.03
	end

	def cent_rand ; 10 * (rand - 1 * rand) ; end

	def points num
		(1..num).map do	
			[Complex(cent_rand), 
			 Complex(cent_rand),
			 Complex(cent_rand)]
		end
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(x,y,z)
		# nonlinear oscillator
		# b = 1 ; [	y, -b*y - sin(x), z]

		b= 3 ; k=cos(x*y) # x, y, z all good!
		[y, -x*k -b*y + PI*sin(y), 1]

		# pendulum
		# b = 0 ; [y, -sin(x),1]

		# huygens clocks 
		# b = 2 ; k = 1 # x, y, z all good!
		# [y, -x*k -b*y + cos(z)*4, 1]

		# split up
		# b = 1 ; k = 1.2*sin(-x**2) # x, y, z all good!
		# [y, -x*k -b*y + PI*cos(y), 1]
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

	Xu, Yu = 60, 100

	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |v,u|
			x, y, z = v.map(&:real)
			s, t, r = u.map(&:real)

			stroke r*30+80, 100*z, 100, 40

			# line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [Complex(cent_rand),Complex(cent_rand),Complex(cent_rand)]
		end
	end