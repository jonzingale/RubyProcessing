class ColorCube < Processing::App
  load_library :opengl

  def setup
    size 640, 360, OPENGL
    frame_rate 30
    @x_degree = 45
    @y_degree =  0
    @foreground_hue =   0
    @background_hue = 180
    color_mode HSB, 360
    no_stroke
  end

  def draw
    background @background_hue, 360, 360, 360
    lights
    push_matrix

      translate width / 2, height / 2, 0
      rotate_x radians( @x_degree )
      rotate_y radians( @y_degree )
      fill @foreground_hue, 360, 360, 320
      box 180

    pop_matrix
    @x_degree  = ( @x_degree + 1 ).modulo 360
    @y_degree  = ( @y_degree + 2 ).modulo 360
    @foreground_hue = ( @foreground_hue +   1 ).modulo 360
    @background_hue = ( @foreground_hue + 180 ).modulo 360
  end

end
ColorCube.new :title => "My COLORFUL Cube!"