class ComplexScreen
  attr_reader :width, :height, :center, :scale, :aspect,
              :all_coords, :shuffled_coords
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
    @all_coords = (0...width).to_a.product((0...height).to_a)
    @shuffled_coords = @all_coords.shuffle

    start_coloring
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
    @queue.clear
    @thread.join
  end

  def changed?
    @changed
  end

  def recenter (x, y)
    update_and_remap(center: screen_to_complex(x, y))
  end

  def zoom (z, x=nil, y=nil)
    c = (x && y) ? screen_to_complex(x, y) : center
    update_and_remap({ center: c, scale: scale * z })
  end

  def get_value_at (x, y)
    @img.pixels[coords_to_index(x, y)]
  end

  def set_value_at (x, y, val)
    @queue << [x, y, val]
  end

  def get_value_at_complex (c)
    get_value_at(*complex_to_screen(c))
  end

  def set_value_at_complex (c, val)
    set_value_at(*complex_to_screen(c), val)
  end

  def coords_to_index (x, y)
    x + (y * width)
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
    dc1 = screen_to_complex(0, 0)
    dc2 = screen_to_complex(width, height)

    old_img = $app.create_image(width, height, Processing::App::RGB)
    old_img.copy(img, 0, 0, width, height, 0, 0, width, height)

    @width = options[:width] if options[:width]
    @height = options[:height] if options[:height]
    @center = options[:center] if options[:center]
    @scale = options[:scale] if options[:scale]

    dx1, dy1 = *complex_to_screen(dc1)
    dx2, dy2 = *complex_to_screen(dc2)
    dw, dh = dx2 - dx1, dy2 - dy1
    tmp_img = $app.create_image(width, height, Processing::App::RGB)
    tmp_img.copy(old_img, 0, 0, width, width, dx1, dy1, dw, dh)
    @img = tmp_img
    @changed = true
  end

  def update_image
    @img.update_pixels
    $app.image(@img,0,0)
    @changed = false
  end
end
