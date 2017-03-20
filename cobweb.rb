  def setup
    size displayWidth, displayHeight
    colorMode HSB, 360, 100, 100, 100
    stroke 12, 60, 100, 100
    stroke_width 1
    fill 0, 0, 0, 7 # see rect
    frame_rate 20
    background 0

    @it = Cobweb.new rand
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
    rect(0, 0, width, height)
    @it.iterate
  end