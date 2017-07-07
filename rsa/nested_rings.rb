# This ruby-processing file generates the group
# multiplication table for p^k rings.

class Ring
  attr_reader :table, :ideal

  def initialize(prime, power)
    @elem_count = prime ** power
    @unit_row = [*0...@elem_count]
    @colors = @unit_row.map { |n| 360 * n / @elem_count }
    @table = [] ; color_it
    @ideal = (0..power).map {|k| k * prime}
  end

  def color_it
    @elem_count.times do |i|
      colored_row = @unit_row.map do |j|
        p_val = i * j % @elem_count
        @colors[p_val]
      end

      @table << colored_row
    end
  end
end

class Chain
  
  MAX_SIZE = 6

  def initialize(prime)
    @ring_index = MAX_SIZE - 1
    @p_rings = (0..5).map { |k| Ring.new(3, k) }
  end

  def selected_subring
    @p_rings[@ring_index].table
  end

  def inc_ring
    @ring_index = (@ring_index - 1) % MAX_SIZE
  end

  def dec_ring
    @ring_index = (@ring_index + 1) % MAX_SIZE
  end
end

def setup
  side = displayHeight
  size(side, side)
  colorMode HSB, 360, 100, 100
  background 0 ; no_stroke
  frame_rate = 1

  @p_rings = Chain.new(3)
end

def pretty_print(board)
  scale = width / board[0].length * 0.85
  board.each_with_index do |row, c_dex|
    row.each_with_index do |c, r_dex|
      x, y = [r_dex, c_dex].map { |i| i*scale + 50 }
      c == 0 ? fill(220,100,40) : fill(c, 70, 100) # zeros are special

      rect(x, y, scale, scale)
    end
  end
end

def select_subring
  if key_pressed?
    clear
    case key_code
    when 38 # up arrow
      @p_rings.inc_ring
    when 40 # down arrow
      @p_rings.dec_ring
    else
      nil
    end
    sleep 0.1
  end
end

def draw
  select_subring
  pretty_print @p_rings.selected_subring
end
