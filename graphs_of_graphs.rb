require 'matrix'

Scale = 1

def setup
  colorMode(HSB,360,100,100,100)
  size displayWidth /1.2, displayHeight /1.2
  @w, @h = width /2.0, height /2.0
  frame_rate 20
  background 0

  ellipse @w, @h, 10, 10 # Center
  @points = (-width/10..width/10).map {|i| [i * 10, i * 10]}
end

class Real
  def initialize x
    @x = x
  end
end

# may not be in jruby.
# define_method(:"γ#{:meth}") { |x| [x, x.send(:meth)] }

# (R -> R) -> (R -> R x R)
# dynamically create a method
# given a method.
def graph_of symbol

end

def tangent_at_p point

end

def unit_orthogonal point

end

def center x, y
  [x * Scale + @w, y * Scale + @h]
end

def fx t
  t * 2
end

def draw
  @points.each do |x1, x2|
    pts = center(x1, fx(x2))
    ellipse( *pts , 5, 5)
  end
end
