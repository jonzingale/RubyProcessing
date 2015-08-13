# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# scrape every hour or so?
# include scrape rate in pic.
require 'nokogiri'
require 'open-uri'
require 'mechanize'

	PI = 3.1415926.freeze
	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	SECONDS = 1200.freeze

	# The coordinates need to be respaced.
	BASE_URL = 'http://forecast.weather.gov/MapClick.php?'.freeze
	CITY_DATA = [['santa fe','87505', [410, 380]],
							 ['bullhead city','86429', [236, 383]],
							 ['cleveland','44107', [1013, 244]],
							 ['monroe','98272', [337, 127]],
							 ['quakertown','18951', [1110, 230]],
							 ['new orleans','70112',[873,571]],
							 ['austin','78705',[634,564]],
							 ['bad lands','57750',[581,221]],
							 ['albuquerque','87101',[382,394]],
							 ['san francisco','94101',[155,278]],
							 ['bismarck','58501',[676,190]],
							 ['helena','59601',[475,219]],
							 ['everglades','34139',[1250,704]],
							 ['annapolis','21401',[1137,299]],
							 ['detroit','48201',[970,240]],
							 ['phoenix','85001',[267,428]]
							]

	def counter ; @i = (@i + 1) % SECONDS ; end

	def scrape_temps
		agent = Mechanize.new ; @data = []
		page = agent.get('http://www.weather.gov')

		CITY_DATA.each do |city, zip, coords|
			form = page.form('getForecast')
			form.inputstring = zip
			page = form.submit

			temp = page.at(CURRENT_TEMP_SEL).text.to_i
			@data << [temp,coords]
		end
	end

	def setup
		text_font create_font("SanSerif",17)

		square = [1600, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		frame_rate 1 ; colorMode(HSB,360,100,100)
		no_stroke

		@my, @mx = [0,0]
		@i, @t = [0 , 1]

		# border color scale
		(0..150).each{|i| fill(scale(i),100,100)
											ellipse(i*9,height,20,20) }

		# scaling is a bitch, don't touch
		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		scrape_temps
	end

	def scale(temp) # linear
		scale = 360 * ((136-temp)/136.to_f)
		translate = scale - 82 % 360
	end	

	def images
		if @i == 0
			scrape_temps ; @t += 1
			save(USA_MAP_TEMP)

			# loads, then displays loaded pic.
			@loaded = loadImage(USA_MAP_TEMP)
			image(@loaded,0,0)
		end
	end

	def draw
		counter

		@data.each do |temp,coords|
			hue = scale(temp)

			# add some random walk sway.
			# make a shadow?
			x, y = coords ; coords = [x , y-@t*7]
			fill(hue,100,100,70) ; rect(*coords,7,7)

			# dont let the number get blurry.
			# fill(0) ; text("#{temp}",*coords)
		end

		message = "granularity: every #{SECONDS/60.0} minutes"
		fill(0,0,100) ; text(message, 75, 660)

		images
	end

#### Testing and IO
	# def mouseMoved
	# 	coords = [mouseX,mouseY]
	# 	fill(0) ; rect(50,50,200,100)
	# 	fill(123,90,90,100)
	# 	text("#{coords}",100,100)
	# end
# ####



