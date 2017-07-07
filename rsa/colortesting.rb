def setup
  text_font create_font("SanSerif",30)
  size(displayWidth/2, displayHeight/2)
  colorMode HSB, 360, 100, 100
  background 0 ; no_stroke
  frame_rate = 1
  @ell_size = [@width/1.9] * 2

  render_image
  images
end

def draw
end

def render_image
  fill(0, 80, 100, 90) ; ellipse(@width/3, @height/2, *@ell_size)
  fill(130, 100, 100, 90) ; ellipse(@width - @width/3, @height/2, *@ell_size)
end

def mouseMoved
  color = get(mouseX,mouseY)
  hh = hue(color)
  ss = saturation(color)
  bb = brightness(color)

  fill(0,0,0,100) ; rect(0, 0, @width, 40)
  fill(180,100,100) ; text("#{hh.floor} #{ss.floor} #{bb.floor}", 15, 30)
end

IMAGES_PATH = File.expand_path('.', File.dirname(__FILE__)).freeze
TMP = "#{IMAGES_PATH}/tester_tmp.jpg".freeze

def images
  # saves, loads, then displays.
  save(TMP) ; clear
  loaded = loadImage(TMP)
  image(loaded,0,0)
end