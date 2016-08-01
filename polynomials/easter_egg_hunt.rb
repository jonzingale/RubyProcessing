# sprinkle over torus
# random walk the radius R

require 'matrix'
include Math

	def setup
		frame_rate 8
		size(1200,800)
		@w,@h = [400] * 2
		@i, @j, @t = [0] * 3

		colorMode(HSB,360,100,100)
		text_font create_font("SanSerif",10)

		background(0)
		@all_coords = (0..9000).map{ sprinkle }
		@all_diagonals = (0..1000).map{ sprinkle_diag }
		@all_curve = (0..1000).map{ sprinkle_curve }
	end

	def set_diag_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten

		color = [rand(60), 0 , 100]
		# color = [rand(60), (a + 2) * 60 , 100]
		fill(*color) ; set(x+@w, z+@h, color(*color))
	end

	def set_curve_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten

		color = [rand(300), 100 , 100]
		fill(*color) ; set(x+@w, z+@h, color(*color))
	end

	def set_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}

		color = [(c * 1600), 
						 ((a+10) * 20), 
						 100]

		# color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
		fill(*color) ; set(x+@w, z+@h, color(*color))
	end

	def sprinkle_curve
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (RAD + cos_p) * cos_p * 2
		y = (RAD + cos_p) * sin_p
		z = sin_p * 3

		Matrix.columns([[x,y,z]])
	end

	def sprinkle_diag
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (RAD + cos_p) * cos_p
		y = (RAD + cos_p) * sin_p
		z = sin_p + 0

		Matrix.columns([[x,y,z]])
	end

	def sprinkle
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (RAD + cos_p) * cos_t
		y = (RAD + cos_p) * sin_t
		z = sin_p + 0

		Matrix.columns([[x,y,z]])
	end

	RAD = PI
	SCALE = (300 / (1 + RAD).to_f).freeze

	def sin_cos(var)
		[:sin, :cos].map {|s| send(s, 2 * PI * var) }
	end

	def draw
		# clear

		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i += 0.001)*2*PI-4*PI}")}
		tranny = [[1,0,0],[sin,cos,0],[0,sin,cos]]		
		rotation = Matrix.rows(tranny)

		@all_coords.each do |mtrx|
			x_y_z = (rotation * SCALE * mtrx).to_a.flatten
			set_color(*x_y_z,mtrx)
		end

		@all_diagonals.each do |mtrx|
			x_y_z = (rotation * SCALE  * mtrx).to_a.flatten
			set_diag_color(*x_y_z,mtrx)
		end

		@all_curve.each do |mtrx|
			x_y_z = (rotation * SCALE  * mtrx).to_a.flatten
			set_curve_color(*x_y_z,mtrx)
		end
	end
