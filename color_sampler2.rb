require (File.expand_path('./color_crawlers', File.dirname(__FILE__)))

# Todo
# crawl color gradients
# find best_possible RGB
# color matchers
# energy curves (equipotential)
# Winston points out that Euclidean metric
#    might not be what I want as it matches
#    luminosity most likely.
# If not close enough, give up and walk
# a second guesser that emulates shaking the mouse!!

	module ColorConversion
		def rgb_converter(m=0,n=0)
			k = get(m,n)
			r = 256 + k/(256**2)
			g = k/256 % 256
			b = k % 256
			[r,g,b]
		end
	end

	class BeingInTheWorld
		include ColorConversion

		def suggest(crawler)
			@m = @m.nil? ? [0,0,0] : rgb_converter(mouseX,mouseY)
			crawler.desired(@m)
		end

		def perceive(crawler)
			theres = crawler.look_z
			those = theres.map{|root,there| [root,rgb_converter(*there)]}
			crawler.see(those)
		end
	end

	include ColorConversion
	attr_reader :thing, :crawler_z
	def setup
		text_font create_font("SanSerif",25) ; no_stroke
		@img = loadImage("/Users/Jon/Desktop/CIE_1931.png")
		@jmg = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")
		# @img = loadImage("/Users/Jon/Desktop/scans/apollonius.jpg");

		# size(displayWidth/2.3, displayHeight/1.3)
		# size(displayWidth, displayHeight/1.1)

		# width, height
		# size(1400,1080) #HOME
		size(1920,1080) #JackRabbit
		background(20) ; frame_rate 30
		@w,@h = [width,height].map{|i|i/2.0}
		@i = 0

		@crawler_z = ColorCrawlers.new('z',@w,@h)
		@thing = BeingInTheWorld.new
	end

	def images
		if @i < 1
			image(@jmg,10,10) # left picture
			scale(0.3) ; image(@img, 1.8*width, 10) ; scale(10/3.0) #CIE
			# scale(0.6) ; image(@img, width-450, 10) ; scale(5/3.0) #APOLLONIUS
			save('/Users/Jon/Desktop/test.png')
			@loaded = loadImage("/Users/Jon/Desktop/test.png") ; @i = 1
		else
			image(@loaded,0,0) ; @loaded = get
		end
	end

	def be_in_world(crawler)
		thing.suggest(crawler)
		thing.perceive(crawler)
		crawler.motive_z

		pos = crawler.position
		name = crawler_z.name
		fill 0 ; text(name,*pos)
	end

	def ellipses
		# color ellipse
		@m = @m.nil? ? [0,0,0] : rgb_converter(mouseX,mouseY)
		fill(*@m,250) ; ellipse(width-300,height-300,200,200);
		fill(255,255,255) ; text("#{@m}",width-480,height-150)

		# best guess ellipse
		pos = crawler_z.position
		color = rgb_converter(*pos)
		fill(*color,200) ; ellipse(width-200,height-300,200,200)
		fill(255,255,255) ; text("#{color}",width-340,height-250)
	end

	def draw
		images
		be_in_world(crawler_z)
		ellipses

		# # show best guess distance
		# text("#{crawler_z.guess.round}",100,40)
	end
