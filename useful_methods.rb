# sprinkle over torus
# random walk the radius R
require 'matrix'
require 'mechanize'

	APARTMENT_URL = 'http://santafe.craigslist.org/search/apa'.freeze

  # load_library :video
    
  # We need the video classes to be included here.
  # include_package "processing.video"

# gets the good ones!!!!
# (row.methods - Object.methods).sort

	def setup
		size(displayWidth, displayHeight)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)
	  tint(200, 153, 204,100)

		background(0)
		@all_coords = (0..3000).map{ sprinkle }
		@all_diagonals = (0..500).map{ sprinkle_diag }

		#### video capture
		# @sample_rate = 10

		# or you can use your default
		# webcam by leaving it out of
		# the parameters ..
		#     
		# camera = "Sony Eye Toy (2)"
		# @capture = Capture.new(self, width, height, camera, 30)

		# @capture = Capture.new(self, width, height, 30)
		# @capture.start
	end

	def sin_cos(var) ; %w(sin cos).map {|s| Math.send(s, 2 * PI * var) } ; end

	cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i += 0.004)*PI}")}
	
	def abs(i) ; ((i**2)**0.5).to_f ; end

	def gcd(a,b)	
		if b == 0 ; a ; else ;
			q = a < b ? [a, b % a] : [b, a % b]
			gcd(*q)
		end
	end

	def text_block(string='')
		fill(0,0,0)
		rect(90,80,200,40)
		fill(200, 140, 100)
		text(string,100,100)
	end

	def trigs(theta)#:: Theta -> R2
	  %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
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

	def all_pairs(height,width)
		(0...height).inject([]){|a,h|a + (0...width).map{|w|[w,h]} }
	end

	# IN DRAW.
	if mouse_pressed? then text("YO YO YO",400,100) end

	def	mouseMoved#Dragged#Clicked
		@m = rgb_converter(mouseX,mouseY)
	end

	def mouseMoved
		coords = [mouseX,mouseY]
		fill(0) ; rect(50,50,200,100)
		fill(123,90,90,100)
		text("#{coords}",100,100)
	end

	def pretty(it)
		it.map{|i| puts "#{i}"}.compact
	end

	def search(query)
		agent = Mechanize.new
		request_hash = {'max_price' => '1500', 
										'bedrooms' => '2',
									  'searchNearby' => '0', 
									  'query' => query }
	
		agent.get(APARTMENT_URL,request_hash)
	end

	def wait_for_key_press
		begin
		  system("stty raw -echo")
		  str = STDIN.getc
		ensure
		  system("stty -raw echo")
		end
		str
	end

	  def clean_file(file) ; File.open(file, 'w') ; end

	  def pair_to_csv(color, count)
	  	FILE.open(COLOR_FILE, 'a'){|file| file << [color,count] }
	  end


	# a source directory off of crude. --untracked.
	# FILES_PATH = File.expand_path('./..', __FILE__).freeze

	# # some_listing = agent.get(LISTING_STUB % listings_data[5]['id'])
	# file = File.open(FILES_PATH+'/some_listing.html')
	# listing = '' ; file.each { |line| listing << line }
	# listing = Nokogiri.parse(listing)

	##########
	