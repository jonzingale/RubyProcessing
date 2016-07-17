require 'matrix'
require 'cmath'
include CMath
include Math

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 5
		background(0)

		stroke(210,100,100,100)
		stroke_width 1
		@pts = points 7000
		@del_t = 0.03
	end

	def cent_rand ; 30 * (rand - 1 * rand) ; end

	def points num
		(1..num).map do	
			[Complex(cent_rand), 
			 Complex(cent_rand),
			 Complex(cent_rand)]
		end
	end

	def diff(x,y,z)
		# test
		[x*y,cos(x)-sin(y), 10]


		# [y,cos(x.real)-sin(y.real), 10]

		# lattice of pendula
		# [cos(y), sin(x/2.0), 2]

		# a nice image
		# [-exp(y)-(x/2.0), sin(x/1.2), x]

		# nonlinear oscillator
		# b = 1 ; [	y, -b*y - sin(x), z]

		# big production
		# b= 3 ; k=cos(x*y)
		# [y, -x*k -b*y + PI*sin(y), 1]

		# pendulum
		# b = 0 ; [y, -sin(x),1]

		# huygens clocks 
		# b = 2 ; k = 1 # x, y, z all good!
		# [y, -x*k -b*y + cos(z)*4, 1]

		# split up
		# b = 1 ; k = 1.2*sin(x) # x, y, z all good!
		# [y, -x*k -b*y + PI*cos(y), 1]
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

	Xu, Yu = 70, 70

	def draw
		# clear
		improved_euler
		@pts.zip(@next_pts).each do |v,u|

			a, b, c = v
			d, e, f = u
			x, y, z = a.real, a.imag, c.real
			s, t, r = d.real, d.imag, f.real

			x, y, z = v.map(&:real) #:imag
			s, t, r = u.map(&:real)

			stroke r*2+180, 100, 100, 20

			# line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts.map do |x,y,z|
			[x,y,z]
			# [Complex(cent_rand),Complex(cent_rand),Complex(cent_rand)]
		end
	end