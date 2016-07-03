class Bubbles
	def initialize(num, width, height)
  	@coords = (0..num).map { [rand(width), rand(height), 0, 0,
															rand(300)+100,		 		# hue
															rand(100), 						# sat
															rand(100), 						# bright
															75+rand(25),  				# opacity
															rand(5),							# radius_var
															] }
  end

	def trip_x(t) ; rand(20) == 1 ? (-1) ** rand(2) : t ; end
	def trip_y(s) ; rand(3) == 1 ? rand(2) : s ; end

  def walk
  	@coords.map! do |x, y, s, t, hue, sat, bri, opac, r|
  		coords = [x + trip_x(t) * 3, y + trip_y(s) * 2, s, t]
  		coords.map{|i| i % 800} + [hue,sat,bri,opac,r]
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
	  frame_rate 60 #60 # can be higher.
	  text_font create_font("SanSerif",100)
	  no_stroke
	  @coords = Bubbles.new(20, width, height)
	  @sample_rate = 10
	  @capture = Capture.new(self, width, height, 30)
	  @capture.start
	end

	def draw
		@i = (@i+1)%36

	  if @i % 15 == 0 && capture.available
		  capture.read
		  convert_pixels
	 	end

		@coords.walk.each do |x, y, s, t, hue, sat, bri, opac, r|
			fill(hue,sat,bri,Math.sin(@i)*opac)
			ellipse(x, y, 12+ r, 12+ r)
			[x,y,s,t,hue,sat,bri,opac,r]
		end
	end

  def convert_pixels
  	flip = rand 100

    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|        
        pixel = y * capture.width + x

        hue = hue(capture.pixels[pixel])
        sat = saturation(capture.pixels[pixel])
        bri = brightness(capture.pixels[pixel])

      	if flip == 1 
	        e_width = map(hue(capture.pixels[pixel]), 0, 200, 0, 100)#100)
				else
					e_width = map(saturation(capture.pixels[pixel]), 0, 100, 0, 100)#100)
				end

        fill(hue, sat, bri, 40)
        ellipse(x, y, e_width, e_width)     
      end
    end
    capture.update_pixels
  end
end

RainyWindowWithVideo.new title: "RainyWindowWithVideo"