require 'mandubrot/complex_screen.rb'
require 'mandubrot/fractal.rb'
require 'mandubrot/thread_pool.rb'

def setup
  # size 1024, 768
  # size 10, 10
  size displayWidth, displayHeight

  @font = create_font "Arial", 16, true
  text_font @font

  frame_rate = 30

  @draw_time = nil
  @mandelbrot = Fractal.new do |n, c|
    (n ** 2) + c
  end
  # @mandelbrot = Fib.new
  @complex_screen = ComplexScreen.new(width: width, height: height, aa: 2)

  @thread_pool = ThreadPool.new(8) do |y|
    h2 = height / 2
    (0...width).to_a.each do |x|
      render_pixel(x, h2 - y)
      render_pixel(x, y + h2)
    end
  end

  @thread_pool.set_work((0...(height/2)).to_a)

  colorMode(RGB, 100);
  @color_map = []
  background(color_safe(0,0,0))
  no_stroke

  @show_status = true

  render
end

def draw
  if @complex_screen.changed?
    @complex_screen.update_image
    display_status
  end
end

def render
  @thread_pool.start_work
end

def render_pixel (x, y)
  cx = @complex_screen.screen_to_complex(x, y)
  m = @mandelbrot.escape_iterations(cx)
  @complex_screen.set_value_at(x, y, colorize(m))
end

def color_safe (r, g, b)
  i = r * 65536 + g * 256 + b
  unless @color_map[i]
    @thread_pool.synchronize do
      @color_map[i] = color(r, g, b)
    end
  end
  @color_map[i]
end

def colorize (k)
  if k
    n = k
    r = n % 512
    r = 512 - r if r > 255
    g = (n * 8) % 512
    g = 512 - g if g > 255
    b = 256 - (r + g)
    b = 255 - r
    color_safe(r, g, b)
  else
    color_safe(0, 0, 0)
  end
end

# not sure what I'm going to do with this, but it seems useful.
def every_x_seconds(n)
  now = Time.now()
  @counter ||= []
  @counter[n] ||= now
  if (now - @counter[n] >= n)
    @counter[n] = now
    yield
  end
end

def display_status
  if @show_status
    fill(255,255,255)
    status = {
      queue: @thread_pool.queue_size,
      all_threads: ThreadGroup::Default.list.length,
      dimensions: [@complex_screen.width, @complex_screen.height].inspect,
      center: @complex_screen.center,
      scale: @complex_screen.scale,
      max_iterations: @mandelbrot.max_iterations,
      limit: @mandelbrot.limit,
      power: @mandelbrot.power
    }.map { |k, v| "#{k}: #{v}\n" }.join
    text(status, 10, 20)
  end
end

def mouse_pressed
  @complex_screen.zoom(0.5, mouse_x, mouse_y)
  render
end

def key_pressed
  do_render = true
  w2, h2 = @complex_screen.width/2, @complex_screen.height/2
  case key
  when '0'
    @mandelbrot.power = @mandelbrot.power + 0.1
  when '9'
    @mandelbrot.power = @mandelbrot.power - 0.1
  when ']'
    @mandelbrot.max_iterations = [@mandelbrot.max_iterations + 1, 1].max
  when '['
    @mandelbrot.max_iterations = [@mandelbrot.max_iterations - 1, 1].max
  when '}'
    @mandelbrot.max_iterations = [@mandelbrot.max_iterations + 100, 1].max
  when '{'
    @mandelbrot.max_iterations = [@mandelbrot.max_iterations - 100, 1].max
  when '+', '='
    @complex_screen.zoom(0.5)
  when '-'
    @complex_screen.zoom(1.5)
  when 'w'
    @complex_screen.recenter(w2, h2 - 100)
  when 'a'
    @complex_screen.recenter(w2 - 100, h2)
  when 'd'
    @complex_screen.recenter(w2 + 100, h2)
  when 's'
    @complex_screen.recenter(w2, h2 + 100)
  when 'z'
    @show_status = !@show_status
  else
    do_render = false
  end
  render if do_render
end
