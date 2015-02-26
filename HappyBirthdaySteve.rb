# Triangles gone wild

def setup
	text_font create_font("SanSerif",60);
	background(51)
	size(1200,1000);
  # color_mode RGB, 1.0
  frame_rate 1000
  # fill 0.8, 0.6
  fill 2.8, 2.6
  smooth
end

def draw
	text "Happy Birthday Steve!!!" , 300 ,300
	fill(color(rand(255),rand(255),rand(255)))
	bezier(8, 8, 81, 81, 890, 890, 815, 880)
	bezierTangent(0,0,25,50, 1)
  triangle(rand(width), rand(height), rand(width), rand(height), rand(width), rand(height))
  ellipse(rand(width),rand(height),rand(width)/15,rand(height)/15)
end



# noFill();
# bezier(85, 20, 10, 10, 90, 90, 15, 80);
# int steps = 6;
# fill(255);
# for (int i = 0; i <= steps; i++) {
#   float t = i / float(steps);
#   // Get the location of the point
#   float x = bezierPoint(85, 10, 90, 15, t);
#   float y = bezierPoint(20, 10, 90, 80, t);
#   // Get the tangent points
#   float tx = bezierTangent(85, 10, 90, 15, t);
#   float ty = bezierTangent(20, 10, 90, 80, t);
#   // Calculate an angle from the tangent points
#   float a = atan2(ty, tx);
#   a += PI;
#   stroke(255, 102, 0);
#   line(x, y, cos(a)*30 + x, sin(a)*30 + y);
#   // The following line of code makes a line 
#   // inverse of the above line
#   //line(x, y, cos(a)*-30 + x, sin(a)*-30 + y);
#   stroke(0);
#   ellipse(x, y, 5, 5);
# }