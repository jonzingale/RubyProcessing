# Ruby Manor 1
 
 class RubyManor1 < Processing::App
 
   load_library :video
     
   # We need the video classes to be included here.
   include_package "processing.video"
     
   attr_accessor :capture
   
   def setup
   	text_font create_font("SanSerif", 10)
   	colorMode(HSB,360,100,100,100)
 		fill(100,100,100,100)
    frame_rate 10
    smooth
    size(800, 600)
     
    @sample_rate = 10
    @capture = Capture.new(self, width, height, 30)
    @capture.start
     # @capture = Capture.new(self, width, height, camera, 30)
   end
 
   def draw
     capture.read if capture.available
     text("#{@capture.available}",100,100)
     image capture, 0, 0
   end
   
 end
 
 RubyManor1.new title: "Ruby Manor 1"