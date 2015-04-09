	def setup
		# width,height
		square = [800] * 2  + [P3D]
		@w,@h = [square[0]/2] * 2
		size(*square) ; @bs = [height,width].min
		@i = 0 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 10
		no_fill()
	end

	def text_block(string='')
		fill(0,0,0) ; no_stroke
		rect(@w-40,@h-40,@w+40,@h+40)
		fill(200, 140, 0)
		text(string,@w,@h)
	end

	def draw
		# @i += 1
		@i = (@i+1) % 120

		pushMatrix()
		
		lights()
		fill(0,0,0) ; no_stroke
		rect(@w-150,@h-150,@w+150,@h+150)
		fill(*@colors)

		translate(width/2, height/2)
		rotateX(Math.sin(mouseY/100.0))
		# rotateX(2.0*PI*1/6.0)
		rotateY(2.0*PI*(@i % 120)/120.0)
		# rotateZ(2.0*PI*(@i % 4)/4.0)
		box(150)

		popMatrix()
	end
