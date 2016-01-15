# sprinkle over torus
# random walk the radius R
# save as slow frames and edit out to make faster movies.

# use pixels: length to resolve, matrix transformations
# Load3DImg ?

require 'matrix'
	def setup
		frame_rate 7
		size(800,800)
		@w,@h = [400] * 2
		@i, @j = [0] * 2

		colorMode(HSB,360,100,100)
		@all_coords = (0..10000).map{ sprinkle }
		@all_diagonals = (0..700).map{ sprinkle_diag }

	  text_font create_font("SanSerif",10)
	end

	# color setting:
	def set_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}
		color = [(c * 1200) + 200, ((a+10) * 20), 100]
		# color = [c < 0 ? 100 : 200, a < 0 ? 40 : 90 , 100]
		set(x+@w, z+@h, color(*color))
	end

	def set_diag_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten.map{|x| x/(2* PI.to_f)}
		set(x+@w, z+@h, color(0,0,100))
	end
	#

	def sprinkle_diag
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 

		x = (RAD + cos_p) * cos_p
		y = (RAD + cos_p) * sin_p
		z = sin_p

		Matrix.columns([[x,y,z]])
	end

	def sprinkle
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (RAD + cos_p) * cos_t
		y = (RAD + cos_p) * sin_t
		z = sin_p

		Matrix.columns([[x,y,z]])
	end

	# RAD = 0 for circle, RAD 1 for apple, RAD = 2 for torus
	RAD = 2 ; SCALE = (300 / (1 + RAD).to_f).freeze
	def sin_cos(var) ; %w(sin cos).map {|s| Math.send(s, 2 * PI * var) } ; end

	def draw
		clear

		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i += 0.002)*PI}")}
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
	end
