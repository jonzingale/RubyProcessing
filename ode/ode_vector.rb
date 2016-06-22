require 'matrix'

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = width/2.0, height/2.0
    frame_rate 10 ; background 0
		stroke_width 0.1
		@pts = points 2200
		@del_t = 0.07
	end

	# def trigs(theta)#:: Theta -> R2
	#   %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	# end

	# def rootsUnity(numbre)#::Int -> [trivalStar]
	# 	(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	# end

	def cent_rand
		100 * (rand - 1 * rand)
	end

	def points num
		Matrix.build(num, 3) {|row, col| cent_rand }
	end

	def abs(n) ; (n**2)**0.5 ; end

	def diff(vect)
		m = Matrix.columns([
			[-0.3,1 ,0],
			[-0.7, 0.3, 0],
			[-1,0,1],
		])

		vect * m
	end

	def euler
		@next_pts = @pts + diff(@pts) * @del_t
	end

	def improved_euler
		dm = @pts + diff(@pts) * @del_t
		ddm = dm + diff(dm) * @del_t
		@next_pts = (dm + ddm)/2.0
	end

	Xu, Yu = 10, 10

	def draw
		# clear
		improved_euler
		@pts.to_a.zip(@next_pts.to_a).each do |(x,y,z),(s,t,r)|
			stroke (y*x)%360, 100*y*x, 100, 100
			# line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts
	end