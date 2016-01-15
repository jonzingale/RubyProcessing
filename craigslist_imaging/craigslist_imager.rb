	# Import an image of santa fe.
	# Use geocoder to find boundaries.

	def setup
		size(1800,900) ; background(20) ; frame_rate 30 #JR
		# size(1400,850) ; background(20) ; frame_rate 30
		@w, @h = [width,height].map{|i|i/2.0} ; @i = 0
  	@m = [235,18,85]

  	text_font create_font("SanSerif",25) ; stroke(200,200,200)
  	# @img = loadImage("/Users/Jon/Desktop/craigslist_map2.jpg")
  	@img = loadImage("/Users/Jon/Desktop/full_santa_fe.png")
	end

	def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
	def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end
	def mouseMoved ; @c = [mouseX, mouseY] ; end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	# buckman & paseo_nopal - 40,145
	UPPER_LEFT = [35.6986174,-105.9823311].freeze
	# osage and otowi - 85,805
	LOWER_LEFT = [35.6672613,-105.9789475].freeze
	# wilderness gate & comino de cruz blanca - 1366,797
	LOWER_RIGHT = [35.6696974,-105.9009758].freeze
	# Canada Del Norte - 35.700318, -105.907274 - 1391,146
	UPPER_RIGHT = [35.700318, -105.907274].freeze

# ["tune up", {"lat"=>35.6813743, "lng"=>-105.9586742}]
# ["counter culture", {"lat"=>35.672803, "lng"=>-105.962936}]
# ["talin market", {"lat"=>35.6822409, "lng"=>-105.9449063}]
# ["tea house canyon road", {"lat"=>35.6822409, "lng"=>-105.9449063}]
# ["santa fe institute", {"lat"=>35.7003063, "lng"=>-105.9086343}]
# ["whole foods cerrillos", {"lat"=>35.6790087, "lng"=>-105.950571}]
# ["whole foods st francis", {"lat"=>35.6768909, "lng"=>-105.952492}]
# ["center for contemporary arts", {"lat"=>35.6732177, "lng"=>-105.9368006}]
# ["jackrabbit systems", {"lat"=>35.689054, "lng"=>-105.946113}]
# ["sprouts paseo de peralta", {"lat"=>35.6925551, "lng"=>-105.9495959}]
# ["la montinita coop alameda", {"lat"=>35.6894921, "lng"=>-105.9583131}]
# ["kakawa paseo de peralta", {"lat"=>35.6816868, "lng"=>-105.9345726}]
# ["st johns college", {"lat"=>35.666789, "lng"=>-105.912226}]

	# a rectangle of nearly goodness.
	# SANTA_FE = [[35.6672613,-105.9823311],[35.6986174,-105.9823311],
	# 						[35.6672613,-105.907274 ],[35.6986174,-105.907274 ]].freeze
	SANTA_FE2 = [[40,145],[1391,145],
							[40,805],[1391,805]].freeze

	def santa_fe


		r_coords = [[209,229],[440,853],[1523,863]]
		range = ([[0,1],[1,2]]).each do |pair|
			quad = pair.map{|x| r_coords[x] }.flatten
			stroke(30) ; line(*quad)
		end

		# ([[0,1],[1,3],[3,2],[2,0]]).each do |pair|
		# 	quad = pair.map{|x|SANTA_FE2[x]}.flatten
		# 	line(*quad)
		# end
		jackrabbit = [677,351] # to osage is 2.5 miles
		# fill(0,50,120,60) ; ellipse(*jackrabbit,1000,1000)
	end

	def my_house
		coords = [396, 547]
		geocoords = [35.680067,-105.962163]
		fill(100,10,120) ;  ellipse(*coords,10,10)
		text('my house',coords[0],coords[1]+20)
	end 


	def images
		if @i < 1
			scale(10.0/10.0) ; image(@img,20,10)
			save('/Users/Jon/Desktop/test.png')
			@loaded = loadImage("/Users/Jon/Desktop/test.png")
		else
			image(@loaded,0,0)
		end
	end

	def draw
		images ; @i = 1
		@loaded = get
		text("#{@c}", 200,200)
		my_house
		santa_fe
	end