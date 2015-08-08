# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# scrape every hour or so?
require 'nokogiri'
require 'open-uri'
require 'mechanize'

	PI = 3.1415926.freeze
	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze

	BASE_URL = 'http://forecast.weather.gov/MapClick.php?'.freeze
	CITY_DATA = [['santa fe','87505',[355,415]],
							 ['bullhead city','86429',[183,416]],
							 ['cleveland','44107',[772,230]],
							 ['monroe','98272',[108,108]],
							 ['quakertown','18951',[877,214]]
							]

	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze

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
		text_font create_font("SanSerif",20);
		square = [1600, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		frame_rate 20 ; colorMode(HSB,360,100,100)
		no_stroke

		@my, @mx = [0,0]
		@i, @t = [0] * 2

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

	def counter ; @i = (@i + 1) % 120 ; end

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
			x, y = coords ; coords = [x, y - @t * 2]
			fill(hue,100,100,70) ; rect(*coords,10,10)

			# dont let the number get blurry.
			# fill(0) ; text("#{temp}",*coords)
		end

		images
	end
