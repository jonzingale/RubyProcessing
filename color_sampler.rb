# Todo
# crawl color gradients
# find best_possible RGB
# color matchers
# energy curves (equipotential)

	def setup
		text_font create_font("SanSerif",15) ; no_stroke
		@img = loadImage("/Users/Jon/Desktop/CIE_1931.png")
		@jmg = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")
		# @jmg = loadImage("/Users/Jon/Desktop/scans/kolmogorov.jpg");
		@img.loadPixels()
		background(20) ; frame_rate 30
		# width, height
		# size(1920,1080) #JackRabbit
		size(1400,1000) #HOME
		@w,@h = [width,height].map{|i|i/2.0}
  	@walker = [@w+200,@h-200] ; @m = [235,18,85]
	end

	def trigs(theta)#:: Theta -> R2
	  @cos,@sin = %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def	mouseDragged#Clicked#
		@m = rgb_converter(mouseX,mouseY)
	end

	def diff(w)#::R^3->R^3->Distance
		norm = w.transpose.map{|p|p.inject(:-)**2}
		Math.sqrt(norm.inject :+)
	end
	
	def walker_z(p=@walker) # pair tends toward @m
		pair = @low_pair.nil? ? @walker : @low_pair
		pair2 = @high_pair.nil? ? @walker : @high_pair
		triple = rgb_converter(*pair)
		e_ball = rand(100) # <- a fun idea

		unless rgb_converter(*pair) == @m
			@low_pair = rootsUnity(17).min_by do |s|
				unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
				diff([rgb_converter(*unital_color), @m])
			end.zip(pair).map{|rp|rp.inject :+}
		end
		fill(0,0,0) ; ellipse(*@low_pair,10,10)
		# better neighborhoods and guesses
		# sum along rays?
		# spider_plant like sporing?
		# diff of the diff?
		# remember the last n and if jostling make e_ball smaller.

		# complementary white dot, kinda ridiculous
		# @high_pair = rootsUnity(17).max_by do |s|
		# 	unital_color = pair2.zip(s).map{|p,r|p+r*e_ball}
		# 	diff([rgb_converter(*unital_color), @m])
		# end.zip(pair2).map{|rp|rp.inject :+}
		# fill(255,255,255) ; ellipse(*@high_pair,10,10)
	end

	def draw
		image(@jmg,10,10) # kolmogorov
		pushMatrix # CIE_1931
			scale(0.3) ; image(@img, 1.7*width, 10);
		popMatrix	

		# color ellipse
		fill(*@m,255) ; ellipse(width-400,height-300,200,200);
		fill(255,255,255) ; text("#{@m}",width-480,height-250)

		# best guess ellipse
		it = @low_pair.nil? ? @m : rgb_converter(*@low_pair)
		fill(*it,200) ; ellipse(width-300,height-300,200,200)
		fill(255,255,255) ; text("#{it}",width-340,height-350)

		walker_z
	end
