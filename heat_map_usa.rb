# The goal here is show a map of the united states
# and to show, by scraping, how various cities 'warm up'
# as the day begins and 'cool down' as the sun sets.

# diff in humidity as bent line?
	DateNow = DateTime.now.strftime('%B %d, %Y').freeze
	StartTime = Time.now.strftime('%l:%M %P').freeze

	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	SECONDS = 800.freeze

	BASE_URL = 'http://forecast.weather.gov/MapClick.php?'.freeze
	CITY_DATA = [['santa fe','87505', [441, 372]],
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
							 ['helena','59601',[509,223]],
							 ['everglades','34139',[1347,707]],
							 ['annapolis','21401',[1182,301]],
							 ['detroit','48201',[1000,253]],
							 ['phoenix','85001',[327,420]],
							 ['atlanta','30301',[1065,435]]
							]

	class Place
		require 'mechanize'
		attr_accessor :temp, :humidity, :agent, :page, :zipcode, :coords

		def initialize(city,zipcode,coords)
			@city, @zipcode, @coords = city, zipcode, coords
			@page = Mechanize.new.get('http://www.weather.gov')
			@temp, @humidity = 0, 0
		end

		def scrape_temp
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			page = form.submit

			@temp = page.at(CURRENT_TEMP_SEL).text.to_i
		end
	end

	attr_reader :cities, :loaded
	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		frame_rate 1 ; colorMode(HSB,360,100,100)
		no_stroke

		@i, @t = [0 , 1]

		# border color scale
		(0..200).each{|i| fill(scale(i-10),100,100)
											ellipse(i*9,height,20,20) }

		# It would be cool to geocode and place somehow.
		# somekind of linear transformation I suspect.
		# scaling is a bitch, don't touch
		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		@cities = CITY_DATA.map{|data| Place.new(*data) }
		@cities.each{|city| city.scrape_temp}
	end

	def counter ; @i = (@i + 1) % SECONDS ; end

	def scale(temp) # linear
		scale = 360 * ((136-temp)/136.to_f)
		translate = scale - 82 % 360
	end	

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
			cities.each{|city| city.scrape_temp }

			# saves, loads, then displays loaded pic.
			save(USA_MAP_TEMP)
			loaded = loadImage(USA_MAP_TEMP)
			image(@loaded,0,0)
		end
	end

	def draw
		counter
		map_key

		# add some random walk sway. 
		# Make a shadow? humidity for curve?
		cities.each do |city|
			hue = scale(city.temp)
			x, y = city.coords ; coords = [x, y-@t*11]
			fill(hue,100,100,70) ; rect(*coords,11,11)

			# dont let the number get blurry.
			# fill(200,30,100) ; text("#{city.temp}",*coords)
		end

		images
	end

	# def mouseMoved
	# 	coords = [mouseX,mouseY]
	# 	fill(0) ; rect(50,50,200,100)
	# 	fill(123,90,90,100)
	# 	text("#{coords}",100,100)
	# end
