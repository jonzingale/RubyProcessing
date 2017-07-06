# This ruby-processing file generates the group
# multiplication table for p^k rings.

class Table
  attr_reader :table
  def initialize(prime, power)
    @elem_count = prime ** power
    @unit_row = [*0...@elem_count]
    @colors = @unit_row.map { |n| 360 * n / @elem_count }
    @table = [] ; color_it
    # @fibers = compute cosets for some large power
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

def setup
  side = displayHeight
  size(side, side)
  colorMode HSB, 360, 100, 100
  background 0 ; no_stroke
  frame_rate = 1

  @MAX_SIZE = 6
  @group_index = 0
  @pgroups = (0...@MAX_SIZE).map{ |i| Table.new(3, i) }
end

def pretty_print(board)
  scale = width / board[0].length * 0.8
  board.each_with_index do |row, c_dex|
    row.each_with_index do |c, r_dex|
      x, y = [r_dex, c_dex].map { |i| i*scale + 50 }
      c == 0 ? fill(220,100,40) : fill(c, 70, 100)

      rect(x, y, scale, scale)
      # ellipse(x, y, scale, scale)
    end
  end
end

def get_quotient
  if key_pressed?
    clear
    case key_code
    when 38
      @group_index = (@group_index + 1) % @MAX_SIZE
    when 40
      @group_index = (@group_index - 1) % @MAX_SIZE
    else
      nil
    end
    sleep 0.1
    @group_index
  end
end

def draw
  get_quotient
  pretty_print @pgroups[@group_index].table
end
