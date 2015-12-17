# RP_Pong
	class HyperCube
		require 'matrix'
		BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
		ALL_POINTS = (0...2**4).inject([],:<<).freeze

		attr_reader :coords, :rand_c
		def initialize(width, height)
			@rand_c = [width, height].map{|i|i/3.0}+[0,(0..2).map{rand(255)}]
			triangles = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }
			edges = triangles.map{|a,b|[a,b] if BASES.include?(a^b)}.compact
			@coords = edges.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
		end
	end

	class Paddle
		attr_reader :y_val
		def initialize
			@y_val = 200
		end

		def move(y_val)
			(@y_val = y_val) if y_val < 600 && y_val > 200
		end
	end
	
	class Ball
		attr_reader :coords, :color
		TU = 6.28318531.freeze

		def initialize
			@color = [rand(360), 100, 100]
			@coords = [200,200]
			theta = theta_init
 			@vect = [Math.sin(theta), Math.cos(theta)]
			@inc = 4 # move by increment
		end

		def theta_init
			(it = rand) > 0.7 || it < 0.3 ? theta_init : it * TU
		end

		def move
			@coords = @coords.zip(@vect).map{|c,v| c+v*@inc}
			update_vect
		end

		def update_vect
			@vect = boundary?(@coords) ? @vect.zip([1,-1]).map{|v,s|v*s} :
							paddle?(@coords) ? @vect.zip([-1,1]).map{|v,s|v*s} : 
							@vect
		end

		def boundary?(coords)
			top = coords[1] < Low_Bound
			bottom = coords[1] > Hi_Bound
			top || bottom
		end

		def paddle?(coords)
			left = coords[0] < Low_Bound
			right = coords[0] > Hi_Bound
			left || right
		end
	end

	Ball_Size = 40.freeze
	Low_Bound = 100 + Ball_Size/2.0
	Hi_Bound = 700 - Ball_Size/2.0

	def setup
		text_font create_font("SanSerif",17)
		square = [900, 900] ; size(*square)
		@w, @h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		frame_rate 48 ; @i = 0
		@ball, @paddle = Ball.new, Paddle.new
		@cube = HyperCube.new(width, height)
	end

	def mouseMoved ; @paddle.move(mouseY) ; end
	def draw_boundary ; no_fill ; stroke(200,100,100) ; rect(100,100,600,600) ; end

	def draw_ball(coords)
		fill(260, 100, 100)
		ellipse(*coords, Ball_Size, Ball_Size)
	end

	def draw_paddle1(y_val)
		fill(160, 100, 100)
		y_val = @ball.coords[1] # delete when no longer funny
		ellipse(100, y_val, 20, 200 )
	end

	def draw_paddle2(y_val)
		y_val = @ball.coords[1]
		fill(160, 100, 100)
		ellipse(700, y_val, 20, 200 )
	end

	def draw_hypercube
		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i+=0.001)*2*PI}")}
		rotation = Matrix.rows([[cos**2,cos*sin,-sin,0],[-cos*sin,cos**2,0,-sin]])

		transform_edges = [0,1].map do |i|
			(rotation*Matrix.columns(@cube.coords.transpose[i])* height/12.0).transpose.to_a
		end.transpose

		transform_edges.each{|edge|a,b = edge.map{|d,e| [d+@w,e+@h]} ; line(*a,*b)}
		# colors = @cube.rand_c.last
		stroke(260, 100, 100)
	end

	def draw
		clear
		@ball.move
		draw_boundary
		draw_paddle1(@paddle.y_val)
		draw_paddle2(300) # opponent
		draw_hypercube
		draw_ball(@ball.coords)
	end
