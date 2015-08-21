# The goal here is to make falling cyan circles

	class Bubbles
		def initialize(num)
	  	@coords = (0..num).map { [rand(2000), rand(2000), 0, 0,
																170 + rand(90),# hue
																rand(20) + 70, # sat
																rand(10) + 90, # bright
																100            # opacity
																] }
	  end

		def trip_x(t) ; rand(20) == 1 ? (-1) ** rand(2) : t ; end
		def trip_y(s) ; rand(3) == 1 ? rand(2) : s ; end

	  def walk
	  	@coords.map! do |x, y, s, t, hue, sat, bri, opac|
	  		coords = [x + trip_x(t) * 3, y + trip_y(s) * 2, s, t]
	  		coords.map{|i| i % 1920} + [hue,sat,bri,opac]
	  	end
	  end
	end

	def setup
		size(1920,1000) # JackRabbit
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0

    frame_rate 20

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

	  no_fill
	  stroke(200,100,100)
	  stroke_weight(5)

	  @coords = Bubbles.new(60)
	end

	def draw
		clear

		@coords.walk.each do |x, y, s, t, hue, sat, bri, opac|
			stroke(hue,sat,bri,opac)
			ellipse(x,y, 100, 100)
			[x,y,s,t,hue,sat,bri,opac]
		end
	end
