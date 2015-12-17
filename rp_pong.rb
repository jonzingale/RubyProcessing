# RP_Pong
# require 'Matrix'

	module Vector
		def dot_product(vect,wect) ; vect.zip(wect).map{|v,w| v * w}.inject :+ ; end
		def orthogonal(vect,wect)

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
			@coords = [500,500]
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
			@vect = collision?(new_coords) ? @vect.map{|v|-1 * v} : @vect
			@coords = new_coords
		end

		# Checks that movement hasn't caused collision
		def collision?(coords)
			boundary?(coords) || paddle?(coords)
		end

		def boundary?(coords)
			norm = 
			top = coords[1] < 0
			bottom = coords[1] > 600
			top || bottom
		end

		def paddle?(coords)
			left = coords[0] < 0
			right = coords[0] > 800
			left || right
		end

		def reflection(vect,wall)
			# a method which reflects a vector off a given wall.
		end

	end

	def setup
		text_font create_font("SanSerif",17)
		square = [1450, 800] ; size(*square)
		@w,@h = [square[0]/2] * 2 ; background(0)
		colorMode(HSB,360,100,100)
		no_stroke ; frame_rate 100

		@ball = Ball.new
	end

	def draw
		clear
		@ball.move
		coords = @ball.coords

		fill(200,100,100)
		ellipse(*coords, 20,20)
	end
