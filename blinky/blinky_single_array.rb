# ironically slower than blinky_index.rb
# which duplicates objects.
class Blinky
  NEARS = [-1,0,1].product([-1,0,1]).reject{|t| t==[0,0]}

  attr_accessor :board
  def initialize(width=30, height=20)
    @width, @height = width, height
    @ary_size = width * height
    @board = (0...@ary_size).map { rand 2 } * 2
    @i = 0
  end

  def pretty_print
    system('clear')
    pp_board = @board.drop(@ary_size)
    until pp_board.empty? 
      line = pp_board.shift(@width).join('')
      puts line.gsub(/[01]/, '0' => '  ', '1' => '* ')
    end
  end

  def neighborhood val
    row, col = val.divmod @width 

    NEARS.map do |j, i|
      rr = (row + j) % @height
      cc = (col + i) % @width
      @board[rr * @width + cc]
    end
  end

  def blink state, neigh
    sum = neigh.inject :+
    sum == 3 || state == 1 && sum == 2 ? 1 : 0
  end

  def update
    @ary_size.times do |val|
      cell = @board[val]
      neighbors = neighborhood val
      @board[val + @ary_size] = blink cell, neighbors
    end

    @ary_size.times do |val|
      @board[val] = @board[val + @ary_size]
    end
  end

  def run_blinky
    while @i<20**2
      @i += 1
      # sleep(0.3)
      pretty_print
      update
    end
  end
end

# for testing.
require 'Benchmark'
require 'byebug'

def test
  blinky = Blinky.new

  Benchmark.bm do |x|
    x.report{ blinky.run_blinky }
  end
end

test