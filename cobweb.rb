  def setup
    colorMode HSB, 360, 100, 100, 100
    stroke 12, 60, 100, 100
    fill 0, 0, 0, 7 # see rect
    stroke_width 1
    frame_rate 20
    background 0

    @it = Cobweb.new rand
  end

  def settings
    size(displayWidth, displayHeight)
  end

  class Cobweb
    attr_reader :x, :r

    def initialize(x)
      @x, @r = x, 3.7
    end

    def plot coords
      line *coords.map { |t| t*1200 - 200 }
    end

    def iterate
      fx = r * x * (1 - x) # discrete logistic
      plot [x, x, x, fx]
      plot [x, fx, fx, fx]
      @x = fx
    end
  end

  def draw
    rect(-10, -10, width + 10, height)
    @it.iterate
  end