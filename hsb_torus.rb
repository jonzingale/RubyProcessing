# sprinkle over torus
# random walk the radius R
require 'matrix'
	def setup
		frame_rate 7
		size(1080,1080)
		@w,@h = [540] * 2
		@i, @j, @t = [0] * 3

		colorMode(HSB,360,100,100)
		text_font create_font("SanSerif",10)

		background(0)
		@all_coords = (0..3000).map{ sprinkle }
		@all_diagonals = (0..500).map{ sprinkle_diag }
	end

	def set_diag_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten

		color = [rand(60),
						 (a + 2) * 60 ,
						 100]

		fill(*color)
		ellipse(x+@w - 200,
						z+@h - 200,
					  7, 7)
	end


	def set_color(x,y,z,matrix)
		a, b, c = matrix.to_a.flatten

		color = [c < 0 ? 100 : 200,
						 a < 0 ? 40 : 90 ,
						 100]

		fill(*color)
		ellipse(x+@w - 200,
						z+@h - 200,
					  7, 7)
	end

	def sin_cos(var) ; %w(sin cos).map {|s| Math.send(s, 2 * PI * var) } ; end

	def sprinkle_diag
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (2 + cos_p) * cos_p
		y = (2 + cos_p) * sin_p
		z = sin_p + 0

		Matrix.columns([[x,y,z]])
	end

	def sprinkle
		sin_p, cos_p = sin_cos (360 - (rand 360))/360.0 
		sin_t, cos_t = sin_cos (360 - (rand 360))/360.0 

		x = (2 + cos_p) * cos_t
		y = (2 + cos_p) * sin_t
		z = sin_p + 0

		Matrix.columns([[x,y,z]])
	end

	def draw
		clear

		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i += 0.002)*2*PI}")}
		tranny = [[1,0,0],[0,0.707,1],[0,sin,cos]]
		rotation = Matrix.rows(tranny)

		@all_coords.each do |mtrx|
			x_y_z = (rotation * 100 * mtrx).to_a.flatten
			set_color(*x_y_z,mtrx)
		end

		@all_diagonals.each do |mtrx|
			x_y_z = (rotation * 100 * mtrx).to_a.flatten
			set_diag_color(*x_y_z,mtrx)
		end
	end


	# def text_block(string='')
	# 	fill(0,0,0)
	# 	rect(90,80,200,40)
	# 	fill(200, 140, 100)
	# 	text(string,100,100)
	# end