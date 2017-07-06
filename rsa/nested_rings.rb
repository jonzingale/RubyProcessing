# This ruby-processing file generates the group
# multiplication table for p^k rings.

class Table
  attr_reader :table
  def initialize(prime, power)
    @elem_count = prime ** power
    @unit_row = [*0...@elem_count]
    @colors = @unit_row.map { |n| 360 * n / @elem_count }
    @table = [] ; color_it
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

  @pgroup = Table.new(7, 2)
end

def pretty_print(board)
  scale = width / board[0].length * 0.8
  board.each_with_index do |row, c_dex|
    row.each_with_index do |c, r_dex|
      xy = [r_dex, c_dex].map { |i| i*scale + 50 }
      c == 0 ? fill(240,100,100) : fill(c, 70, 100)

      ellipse(*xy, scale, scale)
    end
  end
end

def draw
  pretty_print @pgroup.table
end
