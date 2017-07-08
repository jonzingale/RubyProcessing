# This ruby-processing file generates the group
# multiplication table for p^k rings.

class Blender
  include Math
  CONV = PI / 180
  VNOC = 180 / PI
  TAU = 2 * PI

  def self.color_to_complex(hue, sat)
    hh = hue * CONV
    ss = sat / 100.0
    Complex(ss * Math.cos(hh), ss * Math.sin(hh))
  end

  def self.blend(colors)
    cs = colors.map{|color| color_to_complex *color}
    avg = cs.inject(0, :+) / cs.length.to_f

    hue = (avg.arg % TAU) * VNOC
    sat = avg.abs * 100

    [hue, sat]
  end
end

class Ring
  attr_reader :table, :ideal

  def initialize(prime, power, colors=[])
    @elem_count = prime ** power
    next_count = prime ** (power - 1)

    @ideal = [*0...prime].map { |i| i * next_count % @elem_count}

    @unit_row = [*0...@elem_count]
    @colors = colors
    
    @table = [] ; color_it
  end

  def color_it
    @elem_count = 1 if @elem_count < 1
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
    @prime = prime
    @p_rings = generate_subrings(prime ** 5) # 243
    @ring_index = 0
  end

  def blender(colors, ideal)
    next_count = ideal[1] # sketch
    coset_colors = (0...next_count).map { |k| ideal.map {|i| colors[i + k] } }
    coset_colors.map { |colors| Blender.blend(colors) }
  end

  def balanced_colors(elem_count)
    colors = (0...elem_count).map { |n| [rand(360), 100] }
    # colors = (0...elem_count).map { |n| [360 * n / elem_count, 100] }
    # (0...@prime)
  end

  def generate_subrings(elem_count)
    colors = balanced_colors(elem_count)

    # better colors how?
    # colors = (0...elem_count).map { |n| [rand(360), 100] }

    val = 0 ; rings = []

    while val < 6
      ring = Ring.new(@prime, 5 - val , colors)
      rings << ring
      colors = blender(colors, ring.ideal)
      val += 1
    end

    rings
  end

  def selected_ideal
    @p_rings[@ring_index].ideal
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
  text_font create_font("SanSerif",10)
  side = displayHeight
  size(side, side)
  colorMode HSB, 360, 100, 100
  background 0 ; no_stroke
  frame_rate = 1

  @p_rings = Chain.new(3)
end

def pretty_print(table)
  scale = width / table[0].length * 0.85
  table.each_with_index do |row, c_dex|
    row.each_with_index do |(hue, sat), r_dex|
      x, y = [r_dex, c_dex].map { |i| i*scale + 50 }

      fill(hue, sat, 100)
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
  text("Ideal: #{@p_rings.selected_ideal.to_s}",60,30)
end
