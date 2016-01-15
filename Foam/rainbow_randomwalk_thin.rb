		def setup
			# width,height
			size(displayWidth, displayHeight)
			@bs = [height,width].min
			@i = 0 ; background(0) ; @walk = 0
			frame_rate 100
			no_fill()
		end

		# def text_block(string='')
		# 	w = width/2
		# 	fill(0,0,0) ; no_stroke
		# 	rect(width-0.6*w,height-20,width,height)
		# 	fill(200, 140, 0);
		# 	text(string,width-0.5*w,height)
		# end

		def print_bezr(t=0)
			strokeWeight(0.2) ; c = 0.95 # green concentration
			bez_coords = [(1-t)**2, [c,2,t,1-t].inject(:*), t**2]
			bez = bez_coords.map {|n| (n * 255) } # applies color to bezier
			fill(*bez);# stroke(*bez)

			# ellipse(x,y,wide,high)
			ellipse(@i,@walk,3,height/100)

			text_block("#{bez.map(&:floor)}")
		end

		def draw
			drunk_walk = rand(-1..1)
			@walk = (@walk % @bs)+ 5 * drunk_walk

			@i = (@i+1) % @bs
			t = (@i/@bs.to_f)*2 # step
			print_bezr(t)
		end