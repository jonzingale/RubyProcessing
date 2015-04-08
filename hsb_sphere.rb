	def setup
		text_font create_font("SanSerif",10);
		square = [800] * 2  + [P3D]
		@w,@h = [square[0]/2] * 2
		size(*square) ; @bs = [height,width].min
		@i = 0 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 10 ; colorMode(HSB,360,100,100)
		no_fill() ; lights()
	end

	def text_block(string='')
		fill(0,0,0) ; no_stroke
		rect(@w-40,@h-40,@w+40,@h+40)
		fill(200, 140, 0)
		text(string,@w,@h)
	end

	def draw
		@i = (@i+1) % 360

		# translate(width/2, height/2)
			#clear
			fill(0,0,0) ; no_stroke
			rect(@w,@h,width,height)

			colors = [@i%360,100,100]

	
			rotateY(@i%360)
			fill(*colors)
			ellipse(@w,@h,200,200)
			# rotateX(Math.sin(mouseY/300.0 - 0.5))
			# rotateY(2.0*PI*(@i % 120)/120.0)

	end
