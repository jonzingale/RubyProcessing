	class Bubbles
		def initialize(num)
	  	@coords = (0..num).map { [rand(2000), rand(2000), 0, 0,
																rand(300)+100, 	# hue
																rand(100), 			# sat
																rand(100), 			# bright
																40,           # opacity
																rand(12)+5,		 # radius_var
																] }
	  end


		def trip_x(t) ; rand(20) == 1 ? (-1) ** rand(2) : t ; end
		def trip_y(s) ; rand(3) == 1 ? rand(2) : s ; end

	  def walk
	  	@coords.map! do |x, y, s, t, hue, sat, bri, opac, r|
	  		coords = [x + trip_x(t) * 3, y + trip_y(s) * 2, s, t]
	  		coords.map{|i| i % 1920} + [hue,sat,bri,opac,r]
	  	end
	  end
	end


	
	def setup
		colorMode(HSB,360,100,100,100)
		size(displayWidth, displayHeight)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 20 # can be higher.
	  text_font create_font("SanSerif",50)
		background(360, 100, 13, 40)

		color = 0,0,0,0
	  fill(*color)
	  stroke(*color)
	  stroke_weight(2)

	  @coords = Bubbles.new(60)
	end


	def draw
		#clear
		#text('jon is balling', 200, 400) #rand(width),rand(height))
		#clear
		@coords.walk.each do |x, y, s, t, hue, sat, bri, opac, r|
			stroke(hue,sat,bri,opac)
			ellipse(x, y, 50 + r, 50 + r)
			[x,y,s,t,hue,sat,bri,opac,r]
		end

	end

	#ellipse(56, 46, rand(60), 55);
	#end

	