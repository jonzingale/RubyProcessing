# StereoGraphic Projections
	LAT_LON_REGEX = /lat=(-?\d+\.\d+)&lon=(-?\d+\.\d+)/.freeze
	CURRENT_TEMP_SEL = './/p[@class="myforecast-current-lrg"]'.freeze
	CURRENT_CONDS_SEL = './/div[@id="current_conditions_detail"]/table/tr'.freeze

	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	PHI = 1.618033988749895.freeze
	PI = 3.145926.freeze
	SECONDS = 900.freeze
	DataPt = 5.freeze

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

	class Place
		require 'mechanize'
		attr_reader :name, :zipcode, :coords, :geocoords, :agent
		attr_accessor :page

		def initialize name, zipcode, coords
			@name, @zipcode, @coords = name, zipcode, coords

			@agent = Mechanize.new
			agent.follow_meta_refresh = true # new data
			agent.keep_alive = false # no time outs
			@page = agent.get('http://www.weather.gov')
			form = page.form('getForecast')
			form.inputstring = self.zipcode
			@page = form.submit

			@geocoords = LAT_LON_REGEX.match(@page.uri.to_s)[1..2].map(&:to_f)
		end
	end



	attr_reader :points, :loaded

	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 30

		@i, @t = [0 , 1]

		rs = 0.70 ; rotateX(PI/5.0)
		@loaded = loadImage(USA_MAP)
		@loaded.resize(1152*rs,718*rs)
		image(@loaded,350,180)

		@cities = CITY_DATA.map{|data| Place.new(*data) }

		@points = @cities.map do |city|
			data = [city.name, *(city.geocoords)]
			Spherical.new(*data)
		end
	end

	def mouseMoved
		@points.map{ |pt| pt.stereo_pi width, height }
		# @points.each { |pt| text(pt.name,pt.radius,pt.angle) }
	end

	class Spherical
		require 'matrix'
		attr_accessor :phi, :theta, :radius, :angle, :name
		def initialize(name,lat,lon)
			@name = name
			@phi = to_rad(lat)
			@theta = to_rad(-lon)
			self.rotation(PI/2.0)

			@radius, @angle = 0, 0
		end

		def rotation(rad)
			cos, sin = Math.cos(rad), Math.sin(rad)

			rotation = [[cos, -sin],[sin, cos]]
			rotate_by = Matrix.columns(rotation)

			coords = Vector.elements([self.phi, self.theta])

			@phi, @theta = (rotate_by * coords).to_a
		end

		def to_rad(deg)
			deg * PI / 180.0
		end

		def stereo_pi width, height
			scale_h = 1/2.0
			scale_w = 1.8
			mx, my = mouseX.nil? ? [1,1] : [mouseX-width/1.8, mouseY * 5 ]
			@radius = (mx * scale_w  / Math.tan(phi/2.0)) - width/3.5
			@angle = theta * my * scale_h + height * 1.7
		end
	end

	def images
		if @i == 0 ; @t += 1

			# saves, clears, loads, then displays.
			save(USA_MAP_TEMP) ; clear

			loaded = loadImage(USA_MAP_TEMP)
			image(loaded,0,0)

			#where to add
			@points.each { |pt| text(pt.name,pt.radius,pt.angle) }

		end
	end


	def draw
		images
	end

