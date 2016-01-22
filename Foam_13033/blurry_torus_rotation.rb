# sprinkle over torus
# random walk the radius R
require 'matrix'
	def setup
		text_font create_font("SanSerif",10)
		square = [1980] * 2  + [P3D] # 800
		@w,@h = [square[0]/2] * 2
		size(*square)

		@i, @t = [0] * 2 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 10 ; colorMode(HSB,360,100,100)
		no_fill() ; lights() ; no_stroke
	end

	def text_block(string='')
		fill(0,0,100) ; no_stroke
		rect(@w-40,@h-40,@w+40,@h+40)
		fill(200, 140, 0)
		text(string,@w,@h)
	end

	def sprinkle
		sin_p, cos_p = %w(sin cos).map{|s| Math.send(s, 2*PI*(rand 360)/360)* -1**(rand 2) }
		sin_t, cos_t = %w(sin cos).map{|s| Math.send(s, 2*PI*(rand 360)/360)* -1**(rand 2) }

			#  just the diagonal
			# x = (2 + cos_p) * cos_p
			# y = (2 + cos_p) * sin_p
			# z = sin_p

			# generally
			x = (2 + cos_p) * cos_t
			y = (2 + cos_p) * sin_t
			z = sin_p

			Matrix.columns([[x,y,z,1]])
	end

	def abs(i) ; ((i**2)**0.5).to_i ; end

	def draw
		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i+=0.001)*2*PI}")}
		clear
		all_coords = (0..920).map{ sprinkle }

		all_coords.each do |mtrx|
			rotation = Matrix.rows([[cos * cos, sin * cos, 0, 0],
														  [0, cos * sin, 0, 0],
														  [0, 0, 2 * sin, 0],
														  [0, 0, 0, 1]  
														 ])
	
			r = 50
			x, y ,z, w = (rotation * (6 * mtrx)).to_a.flatten
	
			color = [y < 0 ? 100 : 200,
							 abs(mtrx.to_a.flatten[0] * 100),
							 w < 0 ? 50 : 100,
							 z < 0 ? 50 : 100]

			fill(*color)
			ellipse(r*x+@w - 0,
							r*z+@h - 300,
						  20,20)

			set(r*x+@w - 0,
					r*z+@h - 100,
					 color(*color))
		end
	end









