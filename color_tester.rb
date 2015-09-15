	def setup
		size(displayWidth, displayHeight)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

		background(0)
		@img = loadImage("/Users/Jon/Desktop/salmon.jpeg")
		scale(2) ; image(@img,0,0)

	end

	def draw

		text_block
	end
	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def	mouseMoved#Dragged#Clicked
		@m = rgb_converter(mouseX,mouseY)
	end

	# def mouseMoved
	# 	coords = [mouseX,mouseY]
	# 	fill(0) ; rect(50,50,200,100)
	# 	fill(123,90,90,100)
	# 	text("#{coords}",100,100)
	# end

	def text_block(string='')
		fill(0,0,0)
		rect(90,80,200,40)
		fill(200, 140, 100)
		text("#{@m}",100,100)
	end
