class RubyManor3 < Processing::App
  load_library :video
  include_package "processing.video"

  attr_accessor :capture, :sample_rate
  
  def setup
    frame_rate 10
    smooth
    # size(displayWidth,displayHeight)
    size(800, 600)
    no_stroke
    
    @sample_rate = 10
    @capture = Capture.new(self, width, height, 30)
    @capture.start
  end

  def draw
    capture.read if capture.available
    convert_pixels
  end
  
  def clear
    background 255
    ellipse_mode(CORNER)
  end
  
  def convert_pixels
    clear
    
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|
        
        pixel = y * capture.width + x
        
        r = red(capture.pixels[pixel])
        g = green(capture.pixels[pixel])
        b = blue(capture.pixels[pixel])

        e_width = map(saturation(capture.pixels[pixel]), 0, 255, 0, 30)
        # e_width = map(brightness(capture.pixels[pixel]), 0, 255, 0, 20)
        # e_width = map(red(capture.pixels[pixel]), 0, 255, 0, 20)

        fill(r, g, b, 255)
        ellipse(x, y, e_width, e_width)        
      end
    end

    capture.update_pixels
  end
end

RubyManor3.new title: "Ruby Manor 3"