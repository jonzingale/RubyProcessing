class Bubbles
	def initialize(num)
  	@coords = (0..num).map { [rand(1800), rand(1800), 0, 0,
															rand(300)+100,		 		# hue
															rand(100), 						# sat
															rand(100), 						# bright
															05+rand(25),  				# opacity
															50+rand(200),					# radius_var
															] }
  end

	def trip_x(t) ; rand(20) == 1 ? (-1) ** rand(2) : t ; end
	def trip_y(s) ; rand(3) == 1 ? rand(2) : s ; end

  def walk
  	@coords.map! do |x, y, s, t, hue, sat, bri, opac, r|
  		coords = [x + trip_x(t) * 30, y + trip_y(s) * 20, s, t]
  		coords.map{|i| i % 1800} + [hue,sat,bri,opac,r]
  	end
  end
end

class RainyWindowWithVideo < Processing::App
  load_library :video
  include_package "processing.video"

  attr_accessor :capture, :sample_rate

	def setup
		colorMode(HSB,360,100,100,100)
		size(displayWidth, displayHeight)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
	  frame_rate 80 #80 #60 # can be higher.
	  text_font create_font("SanSerif",50)
	  background(100,0,0,0)
	  ellipse_mode(CORNER)
		no_stroke

	  @coords = Bubbles.new(32)
	  @sample_rate = 10
	  @capture = Capture.new(self, width, height, 30)
	  @capture.start
	end

	def draw
		@i = (@i+1)%360

	  if @i % 3 == 0 && capture.available
	  # if capture.available
		  capture.read
		  convert_pixels
	 	end

		@coords.walk.each do |x, y, s, t, hue, sat, bri, opac, r|
			# stroke(hue,sat,bri,Math.sin(@i)*opac)
			fill(hue, sat+rand(60), bri, Math.sin(@i)*opac)
			ellipse(x, y, 12+ r, 12+ r)
			[x,y,s,t,hue,sat,bri,opac,r]
		end
	end

  def convert_pixels
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|        
        pixel = y * capture.width + x

        hue = hue(capture.pixels[pixel])
        sat = saturation(capture.pixels[pixel])
        bri = brightness(capture.pixels[pixel])

        e_width = map(saturation(capture.pixels[pixel]),
        							0, 200, 0, rand(80) )#100)

        fill(hue, sat, bri, 40) #255)
        ellipse(x, y, e_width, e_width)        
      end
    end

    capture.update_pixels
  end
end

RainyWindowWithVideo.new title: "RainyWindowWithVideo"