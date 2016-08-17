class ComplexScreen
  attr_reader :width, :height, :center, :scale, :aspect
  attr_accessor :img

  def initialize(options)
    @width = options[:width] || 800
    @height = options[:height] || 600
    @center = options[:center] || Complex(-0.25,0)
    @scale = options[:scale] || 1
    @img = options[:img] || $app.create_image(width, height, Processing::App::RGB)
    @img.loadPixels();
    @aspect = width.to_f / height
    @changed = false
    @queue = Queue.new

    start_coloring
  end

  def ui_scale
    width / $app.width.to_f
  end

  def start_coloring
    @thread = Thread.new do
      while true
        x, y, val = @queue.pop
        @img.pixels[coords_to_index(x, y)] = val
        @changed = true
      end
    end
  end

  def end_coloring
    @thread.exit
    @thread.join
    @queue.clear
  end

  def changed?
    @changed
  end

  def resize_by (r)
    new_width = (width * r).to_i
    if (new_width > 200 && new_width < 10000)
      resize(new_width, (height * r).to_i)
    end
  end

  def resize (w, h)
    update_and_remap( width: w, height: h)
  end

  def recenter (x, y)
    update_and_remap(center: screen_to_complex(x*ui_scale, y*ui_scale))
  end

  def zoom (z, x=nil, y=nil)
    c = (x && y) ? screen_to_complex(x*ui_scale, y*ui_scale) : center
    update_and_remap({ center: c, scale: scale * z })
  end

  def set_value_at (x, y, val)
    @queue << [x, y, val]
  end

  def set_value_at_complex (c, val)
    set_value_at(*complex_to_screen(c), val)
  end

  def coords_to_index (x, y)
    [x + (y * width), (width * height) - 1].min
  end

  def index_to_coords (i)
    [i % width, (i / width).floor]
  end

  def screen_to_complex(x, y)
    r = ((x.to_f * 2 / width) - 1) * scale * aspect
    i = ((y.to_f * 2 / height) - 1) * scale
    Complex(r, i) + center
  end

  def complex_to_screen(c)
    delta = c - center
    x = (((delta.real / aspect / scale) + 1) * width / 2).round
    y = (((delta.imag / scale) + 1) * height / 2).round
    [x, y]
  end

  def update_and_remap(options)
    end_coloring

    dc1 = screen_to_complex(0, 0)
    dc2 = screen_to_complex(width, height)

    old_img = $app.create_image(width, height, Processing::App::RGB)
    old_img.copy(img, 0, 0, width, height, 0, 0, width, height)
    old_width = width
    old_height = height

    @width = options[:width] if options[:width]
    @height = options[:height] if options[:height]
    @center = options[:center] if options[:center]
    @scale = options[:scale] if options[:scale]

    dx1, dy1 = *complex_to_screen(dc1)
    dx2, dy2 = *complex_to_screen(dc2)
    dw, dh = dx2 - dx1, dy2 - dy1
    tmp_img = $app.create_image(width, height, Processing::App::RGB)
    tmp_img.copy(old_img, 0, 0, old_width, old_height, dx1, dy1, dw, dh)
    @img = tmp_img
    @img.loadPixels();
    @changed = true

    start_coloring
  end

  def update_image
    @img.update_pixels
    $app.image(@img, 0, 0, $app.width, $app.height)
    @changed = false
  end

  def save(filename)
    @img.save(filename)
  end
end
