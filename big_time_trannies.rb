
	# def setup
	#   size 800, 600, P3D  
	# end

	def setup
		# width,height
		square = [800] * 2  + [P3D]
		@w,@h = ([square[0]/2] * 2) + [P3D]
		size(*square)
		@bs = [height,width].min
		@i = 0 ; background(0) ; @walk = 0
		frame_rate 4
		@colors = (0..3).map{|i|rand(255)}
		no_fill()
	end

	def text_block(string='')
		fill(0,0,0) ; no_stroke
		rect(@w-40,@h-40,@w+40,@h+40)
		fill(200, 140, 0);
		text(string,@w,@h)
	end

	def draw
		@colors = (0..2).map{rand(255)}
		@i += 1 ; fill(*@colors)

		# pushMatrix()
				# popMatrix()

pushMatrix()
noStroke();
lights();
translate(100+rand(@i % @bs),100+rand(@i % @bs), 0);
sphere(rand(30));
popMatrix()

		translate(width/2-rand(@w), height/2-rand(@h)) if (@i % 6) == 0

		translate(width/2, height/2);
		rotate(2*PI*(@i % 5)/5.0)
		rotateX(2*PI*(@i % 3)/3.0)

		# rotate(2*PI*(@i % 3)/3.0);
		rect(-100, -100, 100, 100);


		text_block("#{PI}")
		text_block("this is the shit!")
	end

