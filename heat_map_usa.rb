# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# scrape every hour or so?
require 'nokogiri'
require 'open-uri'
require 'mechanize'

	EXP = 2.718281828.freeze
	BASE_URL = 'http://forecast.weather.gov/MapClick.php?'.freeze
	CITY_DATA = [['santa fe','87505',[360,422]],
							 ['bullhead city','86429',[200,416]],
							 ['cleveland','44107',[775,239]]]

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
		@img = loadImage("/Users/Jon/Desktop/usa_map.gif")
		image(@img, width, height)
		# size(1920,1080) #JackRabbit
		square = [1000, 700] ; size(*square)
		@w,@h = [square[0]/2] * 2
		@i, @t = [0] * 2 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 50 ; colorMode(HSB,360,100,100)
		no_fill() ; lights() ; no_stroke
		scrape_temps
	end

	def	mouseMoved ; @m = [mouseX,mouseY] ; end

	def text_block(string='')
		string += @m.to_s unless @m.nil?
		fill(200, 100, 0) ; text(string,width-200,height-40)
	end

	def scale(temp)
		# (temp/130.0) * 360 # linear
		(1+Math.log(temp/125.0)) * -360 # log
	end

	def draw
		image(@img,10,10)
		@data.each do |temp,coords|
			hue = scale(temp)
			fill(hue,100,100)
			ellipse(*coords,10,10)
			text("#{hue.to_i}",*coords)
		end
		text_block

		(0..120).each{|i| fill(scale(i),100,100) ; ellipse(i*9,height,20,20)}
	end
