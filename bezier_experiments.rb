require (File.expand_path('./bezier', File.dirname(__FILE__)))

	def setup
		size(displayWidth/2.3, displayHeight/1.3)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",30)
		background(0)

		points = [[0,height],[0,0],[width,height]]
		@bezier = Bezier.new(points)
	end

	def draw
		# clear
		pt = @bezier.plot(rand)
		color = [200+rand(100),50+rand(50),100]
		set(*pt,color(*color))
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		fill(0) ; rect(50,50,200,100)
		fill(123,90,90,100)
		text("#{coords}",100,100)
	end

	def text_block(string='')
		fill(0,0,0)
		rect(90,80,200,40)
		fill(200, 140, 100)
		text(string,100,100)
	end
