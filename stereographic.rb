# StereoGraphic Projections
	USA_MAP = "/Users/Jon/Desktop/us_maps/us_topographic.jpg".freeze # 1152 × 718
	USA_MAP_TEMP = '/Users/Jon/Desktop/us_maps/us_topographic_tmp.jpg'.freeze
	PHI = 1.618033988749895.freeze
	SECONDS = 900.freeze
	DataPt = 5.freeze
	GeoCoords  =[[46.5172, 112.121],[35.6785, 105.954],
							 [35.1414, 114.492],[41.4838, 81.8015],
							 [47.8703, 121.881],[40.4396, 75.346 ],
							 [30.0658, 89.9314],[30.267, 97.743	],
							 [43.7274, 101.983],[35.1172, 106.625],
							 [37.775, 122.418	],[46.8055, 100.767],
							 [25.86, 81.385		],[38.9716, 76.503	],
							 [42.3831, 83.1022],[33.4507, 112.068],
							 [33.855, 84.3959	]].freeze

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

	# name , lat ,long
	DATA = CITY_DATA.transpose.first.zip(GeoCoords).map{|data|data.flatten}

	attr_reader :points, :loaded
	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800, P3D] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 30

		@i, @t = [0 , 1]

		# rs = 0.70 ; rotateX(PI/5.0)
		# @loaded = loadImage(USA_MAP)
		# @loaded.resize(1152*rs,718*rs)
		# image(@loaded,350,180)

		@points = DATA.map{|data| Spherical.new(*data) }
	end

	def mouseMoved
		clear
		@points.map{|pt| pt.stereo_pi }
		@points.each{|pt| text(pt.name,pt.radius,pt.angle)}
	end

	class Spherical
		attr_accessor :phi, :theta, :radius, :angle, :name
		def initialize(name,lat,lon)
			@name = name
			@phi = lat
			@theta = lon
			@radius = 0
			@angle = 0
		end

		def stereo_pi
			mx, my = mouseX.nil? ? [1,1] : [mouseX, mouseY]
			@radius = (1/(Math.tan(phi/2)) * mx/10.0 ) + 400
			@angle = theta * my/100.0
		end
	end

	# def images
	# 	if @i == 0 ; @t += 1
	# 		# add changes here?

	# 		# saves, loads, then displays.
	# 		save(USA_MAP_TEMP)
	# 		loaded = loadImage(USA_MAP_TEMP)
	# 		image(loaded,0,0)
	# 	end
	# end


	def draw
		# images
	end

