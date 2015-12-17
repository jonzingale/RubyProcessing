# RP_Pong
# require 'Matrix'

	module Vector
		def dot_product(vect,wect) ; vect.zip(wect).map{|v,w| v * w}.inject :+ ; end
		def orthogonal(vect)
			vect.reverse.zip([1,-1]).map{|v,s|v*s}
		end
	end

	class Paddle
		def initialize(x_coord,y_coord,height,width)
			@coords =  x_coord, y_coord
			@inc = 10 # move by increment
		end
	end	

	class Boundaries
		# board should have hard top and bottom
		# left and right should pass, increment score
		# and reset level.
		def initialize(x_size,y_size)
			@coords =  x_coord, y_coord
			@inc = 10 # move by increment
		end
	end	

	
	class Ball
		include Vector
		attr_reader :coords
		TU = 6.28318531.freeze

		def initialize
			# creates the coordinates and
			# direction of movement for a ball
			@coords = [200,200]
			theta = TU * rand
			@vect = [Math.sin(theta), Math.cos(theta)]
			@inc = 10 # move by increment
		end

		# Moves ball along some direction at 
		# some increment. If a collision, 
		# change the direction. Collisions can
		# happen between a paddle and the ball
		# or between the ball and a wall.
		def move
			new_coords = @coords.zip(@vect).map{|c,v| c+v}
			# not realistic bounce. dotproduct with boundary to be sure.

			@vect = boundary?(new_coords) ? @vect.zip([1,-1]).map{|v,s|v*s} : @vect
			@vect = paddle?(new_coords) ? @vect.zip([-1,1]).map{|v,s|v*s} : @vect
			@coords = new_coords
		end

		# Checks that movement hasn't caused collision
		def collision?(coords)
			boundary?(coords) || paddle?(coords)
		end

		def boundary?(coords)
			# norm = 
			top = coords[1] < Low_Bound
			bottom = coords[1] > Hi_Bound
			top || bottom
		end

		def paddle?(coords)
			left = coords[0] < Low_Bound
			right = coords[0] > Hi_Bound
			left || right
		end

		def reflection(vect,wall)
			# a method which reflects a vector off a given wall.
		end

	end

	Ball_Size = 40.freeze
	Low_Bound = 100 + Ball_Size/2.0
	Hi_Bound = 700 - Ball_Size/2.0

	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		frame_rate 300

		stroke(200,100,100)
		@ball = Ball.new
	end

	def draw_boundary
		no_fill ; rect(100,100,600,600)
	end

	def draw_ball(coords)
		# fill(200,100,100)
		ellipse(*coords, Ball_Size, Ball_Size)
	end

	def draw
		clear
		@ball.move
		draw_boundary
		draw_ball(@ball.coords)
	end
