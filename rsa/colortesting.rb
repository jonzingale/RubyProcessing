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

# IMAGE SAVING AND LOADING
IMAGES_PATH = File.expand_path('.', File.dirname(__FILE__)).freeze
TMP = "#{IMAGES_PATH}/tester_tmp.jpg".freeze

def images
  # saves, loads, then displays.
  save(TMP) ; clear
  loaded = loadImage(TMP)
  image(loaded,0,0)
end

# BLENDER
CONV = PI / 180
VNOC = 180 / PI
TAU = 2 * PI

def color_to_complex(color)
  hh = hue(color) * CONV
  ss = saturation(color) / 100.0
  Complex(ss * cos(hh), ss * sin(hh))
end

def blend(colors)
  cs = colors.map{|color| color_to_complex color}
  avg = cs.inject(0, :+) / jt.length.to_f

  hue = (avg.arg % TAU) * VNOC
  sat = avg.abs * 100
  [hue, sat].map(&:floor)
end