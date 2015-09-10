# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# diff in humidity as bent line?

# maybe it would be good to persist data so that
# at a mouse_wheel roll one can see data at various scales.
	DateNow = DateTime.now.strftime('%B %d, %Y').freeze
	StartTime = Time.now.strftime('%l:%M %P').freeze

	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	CURRENT_CONDS_SEL = './/div[@id="current_conditions_detail"]/table/tr'.freeze

	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	SECONDS = 800.freeze
	DataPt = 9.freeze

	CITY_DATA = [['helena','59601',[455,177]],
							 ['santa fe','87505', [441, 372]],
							 ['bullhead city','86429', [302, 374]],
							 ['cleveland','44107', [1041, 251]],
							 ['monroe','98272', [355, 130]],
							 ['quakertown','18951', [1147, 230]],
							 ['new orleans','70112',[956,571]],
							 ['austin','78705',[700,554]],
							 ['bad lands','57750',[617,224]],
							 ['albuquerque','87101',[420,407]],
							 ['san francisco','94101',[197,279]],
							 ['bismarck','58501',[706,190]],
							 ['everglades','34139',[1347,707]],
							 ['annapolis','21401',[1182,301]],
							 ['detroit','48201',[1000,253]],
							 ['phoenix','85001',[327,420]],
							 ['atlanta','30301',[1065,435]]
							]

	# probably want to move this into its own world. testing would be easier.
	class Place
		require 'mechanize'
		attr_accessor :temp, :humidity, :agent, :page, :zipcode, :coords,
									:pressure, :dewpoint, :name, :agent

		def initialize(name,zipcode,coords)
			@name, @zipcode, @coords = name, zipcode, coords

			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs

			page = agent.get('http://www.weather.gov')
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			@page = form.submit

			@temp, @humidity, @pressure, @dewpoint = [0] * 4
		end

		def data_grabber(tr,regex)
			regex.match(tr.text)
			$1.nil? ? 0 : $1
		end

		def scrape_data
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			page = form.submit

			temp = page.at(CURRENT_TEMP_SEL).text.to_i

			data = page.search(CURRENT_CONDS_SEL).each do |tr|
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

		# It would be cool to geocode and place somehow.
		# somekind of linear transformation I suspect.
		# scaling is a bitch, don't touch
		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		@cities = CITY_DATA.map{|data| Place.new(*data) }
		@cities.each{|city| city.scrape_data}
	end

	def counter ; @i = (@i + 1) % SECONDS ; end

	def map_key
		fill(0,0,0,90) ; rect(100,570,160,130)

		fill(0,100,100)
		text("started at #{StartTime}",100,620)

		current_time = Time.now.strftime('%l:%M %P')
		message = "currently #{current_time}"
		text(message,100,645)

		message = "#{(SECONDS/60.0).round(1)} minutes"
		fill(0,0,100)
		text(message,140, 678)
		text(DateNow,100, 590)

		fill(30,100,100) ; rect(100,665,15,15)
	end

	def images
		if @i == 0 ; @t += 1
			cities.each{|city| city.scrape_data }

			# saves, loads, then displays.
			save(USA_MAP_TEMP)
			loaded = loadImage(USA_MAP_TEMP)
			image(loaded,0,0)
		end
	end

	def scale_temp(temp) # linear
		scaled = 360 * ((136-temp)/136.to_f)
		translate = scaled - 82 % 360
	end	

	def draw
		counter
		map_key

		# temps
		cities.each do |city|
			x, y = city.coords
 			coords = [x, y-@t*DataPt]
 			hue = scale_temp(city.temp)
			fill(hue,100,100,70) ; rect(*coords,DataPt,DataPt)
		end

		images
	end

