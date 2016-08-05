# Flows on a Torus
require 'ode_torus/euler.rb'
include Math
include Torus

BODY_RESOLUTION = 2000.freeze

def setup
	size displayWidth, displayHeight
	@w, @h = width/2.0, height/2.0
	colorMode(HSB,360,100,100)
	background 0
	frame_rate 10

	@all_coords = body_points BODY_RESOLUTION

	@all_coords.each do |mtrx|
		# x_y_z = (rotation * SCALE * mtrx).to_a.flatten
		x_y_z = mtrx.to_a.flatten
		set_color(*x_y_z,mtrx)
	end

	stroke_width 1
	stroke(200,100,100,100)
	@it = Euler.new 100
end

def set_color(x,y,z,matrix)
	a, b, c = matrix.to_a.flatten.map{|x| x/Tau }
	color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
	set(x+@w, z+@h, color(*color))
end

def body_points(integer)
	(0...integer).map do |x,y|
		x = x/(integer.to_f) * PI
		y = rand * PI
		to_torus x, y
	end
end

def draw
	# clear
	@it.euler
	pts = @it.pts
	qts = @it.qts

	pts.zip(qts).each do |(x,y),(s,t)|
		x, y, z = to_torus(x,y)
		s, t, r = to_torus(s,t)
		stroke z, 100, 100, 80
		line x+@w, y+@h, s+@w, t+@h
	end

	@it.update_points(qts)
end
