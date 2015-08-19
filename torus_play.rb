# Torus Class, JUST THE INNER_PART

class Torus
	require 'matrix'

	def self.radius ; 0.6 ; end
	# def self.radius ; 0.4 ; end
	# def self.radius ; 2 ; end

	def self.abs(i) ; ((i**2)**0.5).to_f ; end

	def self.sin_cos(var)
		%w(sin cos).map {|s| Math.send(s, 2 * PI * var) }
	end

	def self.coords(x,y)
		sin_p, cos_p = sin_cos x
		sin_t, cos_t = sin_cos y

		x = (radius + cos_p) * cos_t
		y = (radius + cos_p) * sin_t
		z = sin_p

		# -abs on cos_p gives inner saddle
		# x = (radius + -abs(cos_p)) * cos_t
		# y = (radius + -abs(cos_p)) * sin_t
		# z = sin_p

		Matrix.columns([[x,y,z]])
	end
end

require 'matrix'
	# RAD = 0 for circle, RAD 1 for apple, RAD = 2 for torus
	SCALE = (200 / (Math.log(2 + Torus.radius) ).to_f).freeze

	ROTATION_Z = Matrix.rows([[Math.cos(0.5*PI),Math.sin(0.5*PI),0],
												    [Math.sin(0.5*PI),Math.cos(0.5*PI),0],
												    [0,0,1]]).freeze

	POLYNOMIAL = [0,0.33333,1,0].freeze # [0,1] is diagonal
	# POLYNOMIAL = [0,1/3.0,10].freeze # [0,1] is diagonal
	# POLYNOMIAL = [0,0,Math.log(1.2)].freeze # [0,1] is diagonal
	CURVE_RESOLUTION = 7000.freeze
	BODY_RESOLUTION = 3200.freeze

	def poly_points(integer)
		(0..integer).map do |x|
			x = x/(integer.to_f) * PI # * 2
			y = POLYNOMIAL.map.with_index{|p,i| p * (x ** i)}.inject(0,:+)

			Torus.coords x, y
		end
	end

	def body_points(integer)
		(0...integer).map do |x,y|
			x = x/(integer.to_f) * PI
			y = rand * PI

			Torus.coords x, y
		end
	end

	def setup
		grid = 800
		frame_rate 7
		size(grid,grid)
		@w, @h = [ grid/2.0 ] * 2
		@i = 0

		colorMode(HSB,360,100,100)
		@all_body = body_points BODY_RESOLUTION
		@one_curve = poly_points CURVE_RESOLUTION
	  # text_font create_font("SanSerif",10)
	end

	# color setting:
	def set_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}
		color = [(c * 1200) + 200, ((a+10) * 20), 100]
		# color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
		set(x+@w, z+@h, color(*color))
	end

	def set_diag_color(x,y,z,matrix)
		a = matrix.to_a.flatten.first
		set(x+@w, z+@h, color( (a+2) * 100,100,100) )
	end
	#

	def draw
		clear
		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i += 0.002)*PI}")}
		# rotation_y = Matrix.rows([[0,1,0],[cos,0,sin],[sin,0,cos]])
		rotation_x = Matrix.rows([[1,0,0],[0,cos,sin],[0,sin,cos]])
		rotation = rotation_x * ROTATION_Z

		# @all_body.each do |mtrx|
		# 	x_y_z = (rotation * SCALE * mtrx).to_a.flatten
		# 	set_color(*x_y_z,mtrx)
		# end

		@one_curve.each do |mtrx|
			x_y_z = (rotation * SCALE  * mtrx).to_a.flatten
			set_diag_color(*x_y_z,mtrx)
		end
	end
