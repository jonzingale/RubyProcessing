require (File.expand_path('./lorenz', File.dirname(__FILE__)))
  # lorenz_reconstruction is a visualization of Takens' Theorem,
  # a delay embedding theorem. Here I reconstruct in phase
  # space the Lorenz attractor from a single variable
  # time series of the Lorenz equations.

  def setup
    size(displayWidth, displayHeight)
    text_font create_font("SanSerif",20)
    colorMode(HSB,360,100,100,60)
    @w, @h = width/2.0, height/2.0
    stroke_width 1 ; no_stroke
    frame_rate 100
    background 0
    plot_text

    fill(100,100,100,100)
    @trajectories = get_trajectories 1
    @delay = [0] * 30 # heuristically found.
  end

  def plot_text
    fill(100,0,100,100)
    text("time series", @w/1.2, @h/1.2)
    text("o.g manifold", @w/4, height/1.3)
    text("reconstructed manifold", width/1.4, height/1.3)
  end

  def get_trajectories num
    (0...num).map{ Lorenz.new }
  end

  def time scale
    @t = ((@t||0) + 1) % (width*scale)
    @t / scale
  end

  def delay component
    @delay.push component
    @delay.shift
  end

  def time_series attractor
    x = time 10.0
    x_plot = ((x % width) + @w)/2.2
    y = attractor.x * 10 + @h/2.6
    # clear a path before the time series
    stroke 0
    line(x_plot, 0, x_plot + 4, @h/1.3)
    no_stroke ; ellipse(x_plot, y, 1, 1) ; y
  end

  def reconstruct attractor
    bt = time_series attractor
    x = bt + @w
    btt = delay bt
    y = btt + @h
    ellipse x + @w/4, y - @h/4, 1, 1
  end

  def plot_lorenz attractor
    x = attractor.x * 15 + @w
    y = attractor.y * 15 + @h
    ellipse x - @w/2, y, 2, 2
  end

  def draw
    @trajectories.each do |t|
      plot_lorenz t
      reconstruct t
      t.blink
    end
  end