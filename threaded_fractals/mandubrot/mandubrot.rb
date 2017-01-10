require 'mandubrot/complex_screen.rb'
require 'mandubrot/fractal.rb'
require 'mandubrot/thread_pool.rb'
require 'cmath'

ROOT5 = 0.44721359549996
PHI = (1+5**0.5)/2.0
PHA = (1-5**0.5)/2.0

def setup
  @save_folder = File.expand_path(File.dirname(__FILE__))

  @start_time = Time.now()
  size 1920/2, 1080/2
  # size displayWidth, displayHeight
  smooth(8)

  @font = create_font "Arial", 16, true
  text_font @font

  frame_rate = 10

  @draw_time = nil
  @fractal = Fractal.new do |n, c|
    # (n ** 2) + c # mandelbrot
    c + ROOT5 * (PHI**n - PHA**n) #fib

    # canyon like
    # trig = n.rect.map{|t| Math.cos(PI*t)}
    # 0.25*(1+4*n-(1+2*n)*Complex(*trig)) * c

    # fluid like
    # trig = n.rect.map{|t| Math.cos(PI*t)}
    # 0.25*(2+7*n-(2+5*n)*Complex(*trig)) + c
  end
  @complex_screen = ComplexScreen.new(width: width, height: height)

  @color_map = []

  @thread_pool = ThreadPool.new(8) do |y|
    h2 = @complex_screen.height / 2
    (0...@complex_screen.width).to_a.each do |x|
      render_pixel(x, h2 - y)
      render_pixel(x, y + h2)
    end
  end

  colorMode(HSB, 100);
  background(color_safe(0,0,0))
  no_stroke

  @show_status = true

  render
end

def draw
  @end_time = Time.now() unless @thread_pool.done?
  if @complex_screen.changed?
    @complex_screen.update_image
    fill(255,255,255)
    display_status
  end
end

def render
  @start_time = Time.now()
  @thread_pool.set_work((0...(@complex_screen.height/2)).to_a)
  @thread_pool.start_work
end

def colorize_pizel(x, y)
  cx = @complex_screen.screen_to_complex(x, y)
  m = @fractal.escape_iterations(cx).to_i
  colorize(m)
end

def blend_color_array(arr)
  retval = [0, 0, 0]
  arr.map do |elems|
    3.times { |i| retval[i] += elems[i] }
  end
  retval.map { |r| r / arr.length.to_f }
end

def render_pixel (x, y, aa=1)
  step = 1 / aa.to_f
  colors = []
  aa.times do |yy|
    aa.times do |xx|
      colors << colorize_pizel(x + xx * step, y + yy * step)
    end
  end
  @complex_screen.set_value_at(x, y, color_safe(*blend_color_array(colors)))
end

def color_safe (r, g, b)
  r = r.to_i
  g = g.to_i
  b = b.to_i
  i = r * 65536 + g * 256 + b
  unless @color_map[i]
    @thread_pool.synchronize do
      @color_map[i] = color(r, g, b)
    end
  end
  @color_map[i]
end

def colorize (k)
  if k.to_i > 0
    n = k
    r = n % 512
    r = 512 - r if r > 255
    g = (n * 16) % 512
    g = 512 - g if g > 255
    b = 256 - (r + g)
    [r, g, b]
  else
    [0, 0, 0]
  end
end


def display_status
  if @show_status
    status = {
      queue: @thread_pool.queue_size,
      all_threads: ThreadGroup::Default.list.length,
      dimensions: [@complex_screen.width, @complex_screen.height].inspect,
      center: @complex_screen.center,
      scale: @complex_screen.scale,
      max_iterations: @fractal.max_iterations,
      limit: @fractal.limit,
      power: @fractal.power,
      done: @thread_pool.done?,
      time: @end_time - @start_time
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
    @fractal.power = @fractal.power + 0.1
  when '9'
    @fractal.power = @fractal.power - 0.1
  when ']'
    @fractal.max_iterations = [@fractal.max_iterations + 1, 1].max
  when '['
    @fractal.max_iterations = [@fractal.max_iterations - 1, 1].max
  when '}'
    @fractal.max_iterations = [@fractal.max_iterations + 100, 1].max
  when '{'
    @fractal.max_iterations = [@fractal.max_iterations - 100, 1].max
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
  when 'h'
    @complex_screen.resize_by(2)
  when 'l'
    @complex_screen.resize_by(0.5)
  when 'p'
    ts = Time.now().strftime('%Y%m%d_%H%M%S')
    filename = "#{@save_folder}/mandubrot_#{ts}.png"
    puts "Saved: #{filename}"
    @complex_screen.save(filename)
    do_render = false
  when 'r'
  else
    do_render = false
  end
  render if do_render
end
