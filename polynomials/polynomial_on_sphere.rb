# Torus Curves

require 'matrix'
include Math

	def sin_cos(var)
		[:sin, :cos].map {|s| send(s, Tau * var) }
	end

	# RAD = 0 for sphere, RAD 1 for apple, RAD = 2 for torus
	RAD = 0.5 ; SCALE = (500 / (1 + RAD).to_f).freeze
	Tau = 2 * PI 

	ROTATION_Z = Matrix.rows([[cos(0.5*PI),sin(0.5*PI),0],
												    [sin(0.5*PI),cos(0.5*PI),0],
												    [0,0,1]]).freeze

	POLYNOMIAL = [0,1/6.0].freeze # [0,1] is diagonal
	CURVE_RESOLUTION = 4000.freeze
	BODY_RESOLUTION = 7200.freeze

	def to_torus(x,y)
		sin_p, cos_p = sin_cos x
		sin_t, cos_t = sin_cos y

		x = (RAD + cos_p) * cos_t
		y = (RAD + cos_p) * sin_t
		z = sin_p

		Matrix.columns([[x,y,z]])
	end

	def poly_points(integer)
		(0..integer).map do |x|
			x = x/(integer.to_f) * Tau
			y = POLYNOMIAL.map.with_index{|p,i| p * (x ** i)}.inject(0,:+)

			to_torus x, y
		end
	end

	def body_points(integer)
		(0...integer).map do |x,y|
			x = x/(integer.to_f) * PI
			y = rand * PI

			to_torus x, y
		end
	end

	def setup
		size(displayWidth, displayHeight)
		@w,@h = width/2.0, height/2.0
		@i = 0

		frame_rate 7
		colorMode(HSB,360,100,100)
		@all_coords = body_points BODY_RESOLUTION
		@all_diagonals = poly_points CURVE_RESOLUTION
	end

	# color setting:
	def set_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/Tau }
		# color = [(c * 1200) + 200, ((a+10) * 20), 100]
		color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
		set(x+@w, z+@h, color(*color))
	end

	def set_diag_color(x,y,z,matrix)
		a = matrix.to_a.flatten.first
		set(x+@w, z+@h, color(z+80,100,100) )
	end

	def draw
		clear
		sin, cos = sin_cos(@i += 0.008)
		rotation_x = Matrix.rows([[1,0,0],[0,cos,sin],[0,sin,cos]])
		rotation = rotation_x #* ROTATION_Z

		# @all_coords.each do |mtrx|
		# 	x_y_z = (rotation * SCALE * mtrx).to_a.flatten
		# 	set_color(*x_y_z,mtrx)
		# end

		@all_diagonals.each do |mtrx|
			x_y_z = (rotation * SCALE  * mtrx).to_a.flatten
			set_diag_color(*x_y_z,mtrx)
		end
	end
