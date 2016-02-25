require 'mandubrot/complex_screen.rb'

# TODO: refactor into separate classes for threading and calculation
class Mandelbrot
  NUM_THREADS = 8
  attr_accessor :screen, :max_iterations, :power
  attr_reader :quick_limit, :limit
  def initialize (options)
    @screen = ComplexScreen.new(options)
    @max_iterations = options[:max_iterations] || 100
    @limit = options[:limit] || 1_000_000
    @threads = []
    @black = color(0)
    @start_time = nil
    @stop_time = nil
    @power = 2
  end

  def to_s
    "#{screen.center}, #{screen.scale}, #{max_iterations}"
  end

  def clear
    fill color(0,0,0)
    rect 0, 0, screen.width, screen.height
  end

  def zoom_in (x=nil, y=nil)
    screen.zoom(0.75, x, y)
  end

  def zoom_out (x=nil, y=nil)
    screen.zoom(1.25, x, y)
  end

  def recenter (x, y)
    screen.recenter(x, y)
  end

  def escape_iterations(c)
    n = Complex(0, 0)
    max_iterations.times do |i|
      n = (n ** power) + c
      return i if escaped?(n)
    end
    return nil
  end

  def escaped?(n)
    ((n.real * n.real) + (n.imag * n.imag)) > limit
  end

  def colorize (n)
    if n
      color((n * 1) % 256, (n * 8) % 256, 255)
    else
      @black
    end
  end

  def render_pixel(x, y)
    n = escape_iterations(screen.screen_to_complex(x, y))
    c = colorize(n)
    screen.set_value_at(x, y, c)
  end

  def render_step(step, quality, max_quality)
    xx = NUM_THREADS * (2 ** max_quality)
    xlimit = screen.width
    ylimit = screen.height
    y = 0
    offset_map = masked_offest(quality, max_quality)
    while y < ylimit
      x = step * (2 ** max_quality)
      while x < xlimit
        offset_map.each do |a, b|
          render_pixel(x + a, y + b)
        end
        x += xx
      end
      y += (2 ** max_quality)
    end
  end

  def render_stop
    @threads.each do |thr|
      if thr
        thr.exit
        thr.join
      end
    end
    @threads = []
  end

  def render
    @start_time = Time.now()
    @stop_time = nil
    render_stop
    NUM_THREADS.times do |i|
      @threads << Thread.new do
        5.times do |j|
          render_step(i, 4-j, 4)
        end
      end
    end
  end

  def done?
    @threads.all? { |thr| !thr.alive? }
  end

  def elapsed
    if done? && @start_time && !@stop_time
      @stop_time = Time.now()
    end
    (@stop_time || Time.now()) - @start_time
  end

  def offsets(q, mq)
    quality = 2 ** q
    max_quality = 2 ** mq
    o = []
    y = 0
    while y < max_quality
      x = 0
      while x < max_quality
        o << [x, y]
        x += quality
      end
      y += quality
    end
    o
  end

  def masked_offest(q, mq)
    o = offsets(q, mq)
    ((q+1)..mq).each do |mask_q|
      o = o - offsets(mask_q, mq)
    end
    o
  end
end

def setup
  # this programmer can't add, so resolutions not divisible by 2**4 will break.
  size 1024, 768
  background(0,0,0)
  no_stroke
  frame_rate 5

  @font = create_font "Arial", 16, true
  @show_status = true

  full_reset

  text_font @font
end

def draw
  update_image
  display_status
end

def update_image
  @m.screen.img.update_pixels
  image(@m.screen.img,0,0)
end

def display_status
  if @show_status
    fill(255,255,255)
    status = {
      dimensions: [@m.screen.width, @m.screen.height].inspect,
      time: @m.elapsed,
      center: @m.screen.center,
      scale: @m.screen.scale,
      max_iterations: @m.max_iterations,
      limit: @m.limit,
      power: @m.power
    }.map { |k, v| "#{k}: #{v}\n" }.join
    text(status, 10, 20)
  end
end

def full_reset
  @m.render_stop if @m
  @m = Mandelbrot.new(width: width, height: height)
  @m.render
end

def mouse_pressed
  @m.zoom_in(mouse_x, mouse_y)
  clear
  @m.render
end

def key_pressed
  w2, h2 = @m.screen.width/2, @m.screen.height/2
  case key
  when '0'
    @m.power = @m.power + 0.1
  when '9'
    @m.power = @m.power - 0.1
  when ']'
    @m.max_iterations = [@m.max_iterations + 1, 1].max
  when '['
    @m.max_iterations = [@m.max_iterations - 1, 1].max
  when '}'
    @m.max_iterations = [@m.max_iterations + 10, 1].max
  when '{'
    @m.max_iterations = [@m.max_iterations - 10, 1].max
  when '+', '='
    @m.zoom_in
  when '-'
    @m.zoom_out
  when 'r'
    @m.render
  when 'w'
    @m.recenter(w2, h2 - 100)
  when 'a'
    @m.recenter(w2 - 100, h2)
  when 'd'
    @m.recenter(w2 + 100, h2)
  when 's'
    @m.recenter(w2, h2 + 100)
  when 'z'
    @show_status = !@show_status
  when '~'
    full_reset
  end
  clear
  update_image
  @m.render
end
