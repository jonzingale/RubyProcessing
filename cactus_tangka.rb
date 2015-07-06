require 'matrix'
WIDTH, HEIGHT = [1400,1080]
POINTS = [[0,HEIGHT],[WIDTH/2,0],[WIDTH,HEIGHT]].freeze

def setup
  size(WIDTH,HEIGHT)
  background(20)
  frame_rate 200  
  @rand_c = (0..2).map{rand(255)}
  [:fill,:stroke].each{|f|send(f,*@rand_c)}
  colorMode(HSB,360,100,100)
  @pos = POINTS.first
end

def next_pt(roll)
  @pos = @pos.zip(roll).map { |pair| pair.inject(0,:+) / 2 }
end

def draw
  point = next_pt POINTS[rand 3]
  ellipse(*point,1,1)
end
