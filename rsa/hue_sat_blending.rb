include Math

# Blends Hues and Saturations in a Color Space.
# WARNING: THIS CODE WILL NOT RUN OUTSIDE OF
# A RUBYPROCESSING CONTEXT AS hue AND saturation
# ARE NOT DEFINED AS FUNCITONS.

CONV = PI / 180
VNOC = 180 / PI
TAU = 2 * PI

# GENERALIZE THIS BLENDING TO K INPUTS
# EITHER BY INDUCTION OR SOMETHING MORE
# ELEGANT.

def color_to_complex(color)
  hh = hue(color) * CONV
  ss = saturation(color) / 100.0
  Complex(ss * cos(hh), ss * sin(hh))
end

def blend(colors)
  cs = colors.map{|color| color_to_complex color}
  avg = cs.inject(0, :+) / jt.length.to_f

  hue = (avg.arg % TAU) * VNOC
  sat = avg.abs * 100
  [hue, sat].map(&:floor)
end