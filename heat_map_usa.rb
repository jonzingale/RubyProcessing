# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# scrape every hour or so?
require 'nokogiri'
require 'open-uri'
require 'mechanize'

	EXP = 2.718281828.freeze
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
			@data << [temp,coords] ; @i = 0
		end
	end

	def setup
		text_font create_font("SanSerif",20);
		@img = loadImage("/Users/Jon/Desktop/usa_map.gif")
		square = [1000, 700] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		frame_rate 20 ; colorMode(HSB,360,100,100)

		@my, @mx = [0,0]
		scrape_temps
	end

	def	mouseMoved 
		x, y = [mouseX,mouseY]
		@my = y/(height.to_f)*360
		@mx = x/(width.to_f)*100
	end

	def scale(temp) # linear
		scale = 360 * ((136-temp)/136.to_f)
		translate = scale - 82 % 360
	end	
	
	# def scale(temp) ; 360 * Math.log(EXP**((80-temp)/80.0)) ; end

	def draw
		image(@img,10,10)
		@data.each do |temp,coords|
			hue = scale(temp)
			stroke_weight(1) ; stroke(0)

			fill(hue,100,100,95) ; rect(*coords,40,40)
			fill(0) ; text("#{temp}",*coords)
		end

		text("#{@i}",200,200)
		no_stroke ; (0..150).each{|i| fill(scale(i),100,100) ; ellipse(i*9,height,20,20)}

		# rescrapes ever 600 frames.
		# todo: temperature worms.
		@i += 1 ; scrape_temps if @i % 600 == 0 
	end
