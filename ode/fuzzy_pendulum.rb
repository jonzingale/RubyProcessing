	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2.0, height/2.0]
		stroke_width 1
		background 0
    frame_rate 10

		stroke 200, 100, 100, 5
		@pts = points 12000
		@del_t = 0.03
	end

	def cent_rand
		10 * (rand - 1 * rand)
	end

	def points num
		(1..num).map do
			[cent_rand, 2*cent_rand, cent_rand]
		end
	end

	def diff(x,y,z)
		b = 1 ; k = 1.2*Math.cos(x) # fuzzy
		[y, - x*k - b*y + PI*Math.sin(y), 1]
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

	Xu, Yu = 100, 90

	def draw
		improved_euler
		@pts.zip(@next_pts).map! do |(x,y,z),(s,t,r)|
			line (Xu*x)+@w, (Yu*y)+@h, (Xu*s)+@w, (Yu*t)+@h
		end

		@pts = @next_pts.map do |x,y,z|
			# [x,y,z]
			[cent_rand, cent_rand, cent_rand]
		end
	end