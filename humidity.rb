# This is an attempt to have meaningful humidity visualization.

# Todo: incorporate the Bezier Class into
# humidity data so that I can sum to the 
# curve depending on the current humidity
# and the history of humidity.
# straight up for none, 90 deg for 100 %

require (File.expand_path('./bezier', File.dirname(__FILE__)))

	DateNow = DateTime.now.strftime('%B %d, %Y').freeze
	StartTime = Time.now.strftime('%l:%M %P').freeze

	LAT_LON_REGEX = /lat=-?(\d+\.\d+)&lon=-?(\d+\.\d+)/.freeze
	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	CURRENT_CONDS_SEL = './/div[@id="current_conditions_detail"]/table/tr'.freeze

	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	PHI = 1.618033988749895.freeze
	SECONDS = 30.freeze
	DataPt = 5.freeze

	CITY_DATA = [['santa fe','87505', [441, 372]],
							 ['bullhead city','86429', [302, 374]],
							 ['cleveland','44107', [1041, 251]]]

	class Place
		require 'mechanize'
		attr_reader :name, :zipcode, :coords, :geocoords, :agent
		attr_accessor :temp, :humidity, :page, :pressure, :dewpoint

		def initialize name, zipcode, coords
			@name, @zipcode, @coords = name, zipcode, coords

			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs
			@page = agent.get('http://www.weather.gov')
			scrape_data

			@geocoords = LAT_LON_REGEX.match(page.uri.to_s)[1..2]
		end

		def data_grabber(tr,regex)
			regex.match(tr.text)
			$1.nil? ? 0 : $1
		end

		def scrape_data
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			@page = form.submit

			@temp = page.at(CURRENT_TEMP_SEL).text.to_i

			page.search(CURRENT_CONDS_SEL).each do |tr|
				/humidity/i =~ tr.text ?  @humidity = data_grabber(tr,/(\d+)%/i) :
				/barometer/i =~ tr.text ? @pressure = data_grabber(tr,/(\d+\.\d+)/i) :
				/dewpoint/i =~ tr.text ?  @dewpoint = data_grabber(tr,/(\d+)°F/i): nil
			end
		end

	end

	attr_reader :cities, :loaded
	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 1

		@i, @t = [0 , 1]

		# border color scale
		(0..200).each{|i| fill(scale_temp(i-10),100,100)
											ellipse(i*9,height,20,20) }

		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		@cities = CITY_DATA.map{|data| Place.new(*data) }
		@cities.each{|city| city.scrape_data}
	end

	def counter ; @i = (@i + 1) % SECONDS ; end

	def images
		if @i == 0 ; @t += 1
			cities.each{ |city| city.scrape_data }
			# saves, loads, then displays.
			save(USA_MAP_TEMP)
			loaded = loadImage(USA_MAP_TEMP)
			image(loaded,0,0)
		end
	end

	def scale_temp temp # linear
		scaled = 360 * ((136-temp)/136.to_f)
		translate = scaled - 82 % 360
	end	

	def plot_temps
		x, y = city.coords
 		coords = [x, y-@t*DataPt]
 		hue = scale_temp(city.temp)
		fill(hue,100,100,70) ; rect(*coords,DataPt*PHI,DataPt)
	end

	def plot_humidity

	end

	def draw
		counter

		cities.each do |city|
			plot_temps
		end

		images
	end

