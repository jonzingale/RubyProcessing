# Flows on a Torus
# require 'ode_torus/euler.rb'
module Torus
	include Math
	Tau = 2 * PI
	RAD = 2 # 0, 1, 2
	SCALE = 450 / (1 + RAD)

	def sin_cos(var)
		[:sin, :cos].map {|s| send(s, Tau * var) }
	end

	def to_torus(x,y)
		sin_p, cos_p = sin_cos x
		sin_t, cos_t = sin_cos y

		x = (RAD + cos_p) * cos_t
		y = (RAD + cos_p) * sin_t
		z = sin_p

		[x,y,z].map{|t| t*SCALE}
	end
end

class Euler
	include Math

	attr_reader :pts, :qts
	def initialize num
		@del_t = 0.007
		@pts = points num
		euler
	end

	def cent_rand
		rand - 1 * rand
	end

	def update_points(pts)
		@pts = pts
	end

	def points num
		(1..num).map { [cent_rand, cent_rand]}
	end

	def diff(x,y)
		# nonlinear oscillator
		# b = 1 ; [	y, -b*y - Math.sin(x)]

		# serpentine
		# b= 0.1 ; k=Math.cos(x*y) # x, y, z all good!
		# [y, -x*k -b*y + PI*Math.sin(y)]

		# pendulum
		# b = 1 ; [y,-b*y +sin(x)]

		# huygens clocks, ie holy fucking hell 
		# b = 1 ; k = 1 # x, y, z all good!
		# [y, -x*k -b*y + 6]

		# split up
		# b = 2 ; k = 1.2*cos(x) # x, y, z all good!
		# [y, - x*k - b*y + PI*sin(y)]

		# sun spots penumbra
		[cos(y*x),x/y]

		# contracts and explands
		# [y, -x/100]
	end

	def euler
		@qts = @pts.map do |x, y|
			s, t = diff x, y
			dx = x + s * @del_t
			dy = y + t * @del_t

			s, t = diff dx, dy
			ddx = dx + s * @del_t
			ddy = dy + t * @del_t

			[(dx + ddx) /2.0, (dy + ddy) /2.0]
		end
	end
end

###############
include Math
include Torus
require 'matrix'

BODY_RESOLUTION = 5000.freeze
ROTATION_Z = Matrix.rows([[0,sin(0.5*PI),cos(0.5*PI)],
											    [0,cos(0.5*PI),sin(0.5*PI)],
											    [1,0,0]]).freeze
def setup
	size displayWidth, displayHeight
	@w, @h = width/2.0, height/2.0
	colorMode(HSB,360,100,100)
	background 0
	frame_rate 5

	stroke_width 100
	@it = Euler.new 3000
end

def set_color(x,y,z,matrix)
	a, b, c = matrix.to_a.flatten.map{|x| x/Tau }
	color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 10]
	set(x+@w, z+@h, color(*color))
end

def body_points(integer)
	(0...integer).map do |x,y,z|
		x = x/(integer.to_f) * PI
		y = rand * PI
		to_torus x, y
	end
end

def draw
	clear
	@it.euler
	pts = @it.pts
	qts = @it.qts

	pts.zip(qts).each do |(x,y),(s,t)|
		x, y, z = to_torus(x,y)
		s, t, r = to_torus(s,t)
		stroke (x/4)%360, 100, 100, 100
		line(x+@w, y+@h, s+@w, t+@h)
	end

	@it.update_points(qts)
end
