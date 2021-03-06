require 'matrix'
include Math

	def setup
		size(displayWidth/2, displayHeight/2)
		@w, @h = width/2.0 , height/2.0
		@i, @j = [0] * 2
		frame_rate 8

		colorMode(HSB,360,100,100)
		@all_coords = (0..8500).map{ sprinkle }
		@all_diagonals = (0..900).map{ sprinkle_diag }
	end

	# BODY:
	def set_body_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}
		color = [(c * 1200) + 200, ((a+10) * 20), 100]
		# color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
		set(x+@w, z+@h, color(*color))
	end

	def abs(i) ; ((i**2)**0.5).to_f ; end

	def sprinkle
		sin_p, cos_p = sin_cos (rand 360)/360.0
		sin_t, cos_t = sin_cos (rand 360)/360.0

		# replace cos_p with -abs(cos_p) for just singularity
		x = (RAD + cos_p) * cos_t
		y = (RAD + cos_p) * sin_t
		z = sin_p

		Matrix.columns([[x,y,z]])
	end
	
	# DIAGONAL:
	def set_diag_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}
		set(x+@w, z+@h, color(200,0,100))
	end

	def sprinkle_diag
		sin_p, cos_p = sin_cos (rand 360)/360.0

		x = (RAD + cos_p) * cos_p
		y = (RAD + cos_p) * sin_p
		z = sin_p

		Matrix.columns([[x,y,z]])
	end

	# one can see that the whole inner core becomes a sphere.
	# RAD = 0 for circle, RAD 1 for apple, RAD = 2 for torus
	RAD = 2.0 ; SCALE = (200 / (1 + RAD)).freeze
	
	def sin_cos(var)
		[:sin, :cos].map {|s| send(s, 2 * PI * var) }
	end
	
	def draw
		clear

		# switch between views
		sin, cos = sin_cos(@i += 0.007)
		tranny = key == '1' ? [[0,1,0],[cos,sin,0],[cos,0,sin]] :
													[[1,0,0],[cos,sin,0],[0,cos,sin]]

		rotation = Matrix.rows(tranny)

		@all_coords.each do |mtrx|
			x_y_z = (rotation * SCALE * mtrx).to_a.flatten
			set_body_color(*x_y_z,mtrx)
		end

		@all_diagonals.each do |mtrx|
			x_y_z = (rotation * SCALE  * mtrx).to_a.flatten
			set_diag_color(*x_y_z,mtrx)
		end
	end
