	# def setup
	# 	background(0) ; @i = 0
	# 	square = [2800] * 2 ; size(*square)
	# 	frame_rate 3 ; colorMode(HSB,360,100,100)
	# end

	# def draw
	# 	w,h = [width/2,height/2]
	# 	@i = (@i+1)%40


	# 	stroke(0)
	# 	fill(rand(360),100,100,@i)
	# 	ellipse(w-w/2,h,width,height)

	# 	fill(rand(360),100,100,@i)
	# 	ellipse(w+w/2,h,width,height)


	# 	fill(rand(360),100,100,@i)
	# 	ellipse(w,h+h/3,width,height)

	# --- breaky_dodge
	def setup
		background(0) ; @i = 0
		square = [800] * 2 ; size(*square)
		frame_rate 0.5 ; colorMode(HSB,360,100,100)
		no_fill
	end

	def draw
		w,h = [width/2,height/2]
		@i = (@i+1)

		(1..30).each do |t|
			if @i < 15 
				fill(360*t/30,20,92,50)

				it = [t*width/10,h,360/10,height].shuffle
				ellipse(*it)
				# ellipse(t*width/10,h,360/10,height)
				# ellipse(w,t*height/10,width,360/7)
			end
		end

		# fill(rand(360),100,100,@i)
		# ellipse(w+w/2,h,width,height)


		# fill(rand(360),100,100,@i)
		# ellipse(w,h+h/3,width,height)		
	end