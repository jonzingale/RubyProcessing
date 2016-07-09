require 'matrix'
require 'cmath'
include CMath

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

	def cent_rand ; 10 * (rand - 1 * rand) ; end

	def points num
		Matrix.build(num, 3) {|row, col| Complex(cent_rand, cent_rand) }
	end
	
	def diff(vect)
		m = Matrix.columns([
			[-0.3,-1 ,-1],
			[0.7, 0.3, 0],
			[-1,1,0],
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
		clear
		improved_euler
		@pts.to_a.zip(@next_pts.to_a).each do |(x,y,z),(s,t,r)|
			stroke (x*y*4)%360, (200*x*y)%100, 100, 40

			line (Xu*x)+@w, (Yu*z)+@h, (Xu*s)+@w, (Yu*r)+@h
			# line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end
		
		@pts = @next_pts
	end