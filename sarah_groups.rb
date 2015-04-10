	def setup
		background(0) ; @i = 0
		square = [800] * 2 ; size(*square)
		frame_rate 3 ; colorMode(HSB,360,100,100)
	end

	def draw
		w,h = [width/2,height/2]
		@i = (@i+1)%40


		stroke(0)
		fill(rand(360),100,100,@i)
		ellipse(w-w/2,h,width,height)

		fill(rand(360),100,100,@i)
		ellipse(w+w/2,h,width,height)


		fill(rand(360),100,100,@i)
		ellipse(w,h+h/3,width,height)
	end