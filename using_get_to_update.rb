# class UsingGetToUpdate
	def setup
		text_font create_font("SanSerif",25) ; no_stroke
		@img = loadImage("/Users/Jon/Desktop/CIE_1931.png")
		@jmg = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")

		# width, height
		size(1400,1000) #HOME
		# size(1920,1080) #JackRabbit
		background(20) ; frame_rate 30
		@w,@h = [width,height].map{|i|i/2.0}
  	@walker = [@w+400,@h-200] ; @m = [235,18,85] ; @i = 0
	end

	def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
	def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end
	def	mouseMoved ; @m = rgb_converter(mouseX,mouseY) ; end
	def euclidean(w) ; Math.sqrt(w.transpose.map{|p|p.inject(:-)**2}.inject :+) ; end
	def rgb_converter(m=0,n=0) ; c,k = [256,get(m,n)] ; [c+k/(c**2),k/c%c,k%c] ; end

	def walker_w(p=@walker) # modifier: leaves a trail of black
		pair = @mod_pair.nil? ? @walker : @mod_pair
		e_ball = rand(100) # <- novel idea
		set(*pair,color(0)) ; @loaded = get(0,0,width,height) # <- modifier, better to get locally

		@mod_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
			euclidean([rgb_converter(*unital_color), @m])
		end.zip(pair).map{|rp|rp.inject :+}

		fill(0,0,0) ; text('w',*@mod_pair)
	end

	def images
		if @i < 1
			image(@jmg,10,10) # left picture
			scale(0.3) ; image(@img, 1.8*width, 10) ; scale(10/3.0) #CIE
			save('/Users/Jon/Desktop/test.png')
			@loaded = loadImage("/Users/Jon/Desktop/test.png")
		else ; image(@loaded,0,0) ; end
	end
	
	def draw
		images ; @i = 1
		walker_w

		# color ellipse
		fill(*@m,250) ; ellipse(width-300,height-300,200,200);
		fill(255,255,255) ; text("#{@m}",width-480,height-150)

		# best guess ellipse
		guess = @mod_pair.nil? ? @m : rgb_converter(*@mod_pair)
		fill(*guess,200) ; ellipse(width-200,height-300,200,200)
		fill(255,255,255) ; text("#{guess}",width-340,height-250)

		text("#{rgb_converter(*@mod_pair)}",200,200)
	end
# end