require (File.expand_path('./lorenz', File.dirname(__FILE__)))
  # lorenz_reconstruction is a visualization of Takens' Theorem,
  # a delay delay embedding theorem. Here I reconstruct the phase
  # space of the Lorenz attractor from a single variable
  # time series Lorenz equations.

  def setup
    size(displayWidth, displayHeight)
    text_font create_font("SanSerif",50)
    colorMode(HSB,360,100,100,60)
    @w, @h = width/2.0, height/2.0
    frame_rate 100
    background 0
    no_stroke

    @trajectories = get_trajectories 1
    @delay = [0] * 30 # heuristically found.
  end

  def get_trajectories num
    (0...num).map{ Lorenz.new }
  end

  def time scale
    @t = ((@t||0) + 1) % (width*scale)
    @t / scale
  end

  def time_series attractor
    x = time 10.0
    y = attractor.x * 10 + @h/2.6
    ellipse(x,y,1,1) ; y
  end

  def delay component
    @delay.push component
    @delay.shift
  end

  def reconstruct attractor
    bt = time_series attractor
    x = bt + @w
    btt = delay bt
    y = btt + @h
    ellipse x, y/1.3, 1, 1
  end

  def plot_lorenz attractor
    x = attractor.x * 15 + @w
    y = attractor.y * 15 + @h
    c = attractor.color ; fill(*c)
    ellipse x/1.4, y, 2, 2
  end

  def draw
    @trajectories.each do |t|
      plot_lorenz t
      reconstruct t
      t.blink
    end
  end