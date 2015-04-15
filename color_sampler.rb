# Todo
# crawl color gradients
# find best_possible RGB
# color matchers
# energy curves (equipotential)

	def setup
		text_font create_font("SanSerif",30);
		@img = loadImage("/Users/Jon/Desktop/CIE_1931.png");
		@jmg = loadImage("/Users/Jon/Desktop/scans/kolmogorov.jpg");
		@img.loadPixels()
		background(20)
		# width, height
		# size(1920,1080) #JackRabbit
		size(1600,1000) #HOME
		@w,@h = [width,height].map{|i|i/2.0}
		frame_rate 30 ; @value = 0
		@t = -1; @s = -1 ; @i = 0
		@r1,@g1,@b1 = [0]*3
  	smooth #; @m = [0,0]
  	@walker = [@w+200,200]
  	@m = [1]*3
	end

	def trigs(theta)#:: Theta -> R2
	  @cos,@sin = %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def text_block(string='')
		fill(0,0,0) ; no_stroke
		rect(0,height-300,width,height)
		fill(200, 140, 0)
		text(string,0,height-200)
	end

	def rgb_converter(m=0)
		r = 256 + m/(256**2)
		g = m/256 % 256
		b = m % 256
		[r,g,b]
	end

	def	mouseDragged
		@m = rgb_converter(get(mouseX,mouseY))
	end

	def diff(w)#::R^3->R^3->Distance
		norm = w.transpose.map{|p|p.inject(:-)**2}
		Math.sqrt(norm.inject :+)
	end
	
	def walker_z(p=@walker) # follows color
		# p,q are starting point, try to get to @m
		p , q = @low_pair.nil? ? @walker : @low_pair
		triple = rgb_converter(get(p,q))

		e_ball = 100 #
		@low_pair = rootsUnity(17).min_by do |s|
			unital_color = get(p+s[0]*e_ball,q+s[1]*e_ball)
			diff([rgb_converter(unital_color), @m])
		end.zip([p,q]).map{|rp|rp.inject :+} # is this right?

		text_block("#{@low_pair}")
		fill(0,0,0) ; ellipse(*@low_pair,10,10)
	end

	def draw
		x,y = [width/2,height/2]

		image(@jmg,10,10) # kolmogorov
		pushMatrix # CIE_1931
			scale(0.3) ; image(@img, 1.7*width, 10);
		popMatrix	

		fill(*@m) # color ellipse
		ellipse(200,height-600,200,200);

		# walk starting point
		walker_z

		fill(0,0,255); # RGB coords
		ellipse(x+200,200,1,1)
		text("#{@m} shit",200,200)
	end
