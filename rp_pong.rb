# RP_Pong
	class HyperCube
		require 'matrix'
		BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
		ALL_POINTS = (0...2**4).inject([], :<<).freeze

		attr_reader :coords, :rand_c
		def initialize(width, height)
			@rand_c = [width, height].map{|i|i/3.0}+[0,(0..2).map{rand(255)}]
			triangles = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }
			edges = triangles.map{|a,b|[a,b] if BASES.include?(a^b)}.compact
			@coords = edges.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
		end
	end

	class Paddle
		attr_reader :y_val, :vect, :side
		# TODO: work on deflecting correctly.
		def initialize(side = 'left')
			@y_val, @vect, @side = 400, 1, side
		end

		def move(y_val)
			boundary_cond = y_val < 600 && y_val > 200
			@y_val = y_val if boundary_cond
		end
	end
	
	class Ball
		attr_reader :coords, :color
		TU = 6.28318531.freeze

		def initialize
			@color = [rand(360), 100, 100]
 			@vect = [Math.sin(TU * rand), 1]
			@coords = 380, 400
			@inc = 8 # ball speed
		end

		def move
			@coords = @coords.zip(@vect).map{|c,v| c + v * @inc}
			boundary?(@coords)
		end

		def boundary?(coords)
			cond = coords[1] < Low_Bound || coords[1] > Hi_Bound
			(@vect = @vect.zip([1,-1]).map{|v,s|v*s}) if cond
		end

		def abs(val) ; Math.sqrt(val**2) ; end

		def paddle?(paddle)
			# How should the deflection happen?
			# when the ball gets behind it still feels the effect.
			left_cond = paddle.side == 'left'
			cond_1 = left_cond ? @coords[0] < Low_Bound : @coords[0] > Hi_Bound
			cond_2 = abs(@coords[1] - paddle.y_val) <  100

			@vect = @vect.zip([-1,1]).map{|v,s|v*s} if cond_1 && cond_2
		end
	end

	Ball_Size = 40.freeze
	Low_Bound = 100 + Ball_Size/2.0
	Hi_Bound = 700 - Ball_Size/2.0

	def setup
		text_font create_font("SanSerif",40)
		size(900, 900) ; background(0)
		colorMode(HSB,360,100,100)
		frame_rate 48 ; @i = 0
		@l_score, @r_score = [0] * 2
		@ball = Ball.new
		@paddle1 = Paddle.new('left')
		@paddle2 = Paddle.new('right')

		@cube = HyperCube.new(width, height)
	end

	def mouseMoved ; @paddle1.move(mouseY) ; end
	def draw_boundary ; no_fill ; stroke(200,100,100) ; rect(100,100,600,600) ; end

	def draw_ball(coords)
		fill(260, 100, 100)
		ellipse(*coords, Ball_Size, Ball_Size)
	end

	def draw_paddle1(paddle)
		fill(160, 100, 100)
		ellipse(100, paddle.y_val, 20, 200 )
	end

	# slower than ball
	# change paddle direction
	# vect roots unity.
	# std badness.
	def draw_paddle2(paddle)
		y_val = @ball.coords[1]
		@paddle2.move(y_val)
		fill(160, 100, 100)
		ellipse(700, y_val, 20, 200 )
	end

	def draw_hypercube
		cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i+=0.001)*2*PI}")}
		rotation = Matrix.rows([[cos**2,cos*sin,-sin,0],[-cos*sin,cos**2,0,-sin]])

		transform_edges = [0,1].map do |i|
			(rotation*Matrix.columns(@cube.coords.transpose[i])* height/12.0).transpose.to_a
		end.transpose

		stroke(200,100,100)
		transform_edges.each do |edge|
			a,b = edge.map{|d,e| [d+400,e+400]}
			line(*a,*b)
		end
	end

	def reset
		text("Left: #{@l_score}", 150, 800)
		text("Right: #{@r_score}", 450, 800)
		if @ball.coords[0] < 10 || @ball.coords[0] > 800
			(@r_score +=1) if @ball.coords[0] < 100
			(@l_score +=1) if @ball.coords[0] > 700
			@ball = Ball.new
		end
	end

	def draw
		clear ; draw_boundary ; draw_hypercube
		[@paddle1, @paddle2].each{|pad| @ball.paddle?(pad)}

		draw_paddle1(@paddle1)
		draw_paddle2(@paddle2) # opponent
		@ball.move ; draw_ball(@ball.coords)
		reset
	end
