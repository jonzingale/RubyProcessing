require 'matrix'

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = width/2.0, height/2.0
    frame_rate 20 ; background 0
		stroke_width 1
		@pts = points 12
		@del_t = 0.2
	end

	# def trigs(theta)#:: Theta -> R2
	#   %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	# end

	# def rootsUnity(numbre)#::Int -> [trivalStar]
	# 	(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	# end

	def cent_rand
		10 * (rand - 1 * rand)
	end

	def points num
		Matrix.build(num, 3) {|row, col| cent_rand }
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(vect)
		m = Matrix.columns([
			[0,-1 ,0],
			[1, 0, 0],
			[0,1,0],
		])

		vect * m
	end

	def euler
		@next_pts = @pts + diff(@pts) * @del_t
	end

	# def improved_euler
		# @next_pts = @pts.map do |v|

			# v + diff(v)
	# 		s, t, r = diff(v).to_a
	# 		dx = x + s * @del_t
	# 		dy = y + t * @del_t
	# 		dz = z + r * @del_t

	# 		s, t, r = diff dx, dy, dz
	# 		ddx = dx + s * @del_t
	# 		ddy = dy + t * @del_t
	# 		ddz = dz + r * @del_t

	# 		[(dx + ddx) /2.0,
	# 		 (dy + ddy) /2.0,
	# 		 (dz + ddz) /2.0]
	# 	end
	# end

	Xu, Yu = 1, 1

	def draw
		# clear
		# improved_euler
		euler
		@pts.to_a.zip(@next_pts.to_a).each do |(x,y,z),(s,t,r)|
			stroke y%360, 100, 100, 70
			# line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts
	end