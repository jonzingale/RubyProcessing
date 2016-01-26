# pushes till far and away bubbles.

class Walker
	attr_reader :color, :size, :coords
	def initialize(width, height)
		# @color = [rand(60)+150, rand(100), rand(30)+70, rand(70) + 30]
		@color = [rand(360), rand(100), rand(30)+70, rand(70) + 30]
		@width, @height = width, height
		@coords = rand(width), rand(height)
		@size = rand(5) + 1
	end

	def set_coords(x, y) ; @coords = x, y ; end

	def walk
		x, y = @coords.map{|v| v + 1 * (rand(3) - 1) }
		@coords = x % @width, y % @height
	end
end

	def setup
		size(displayWidth, displayHeight-45)
		colorMode(HSB,360,100,100,100)
		background(0) ; frame_rate 50
	  text_font create_font("SanSerif",10)

	  @walkers = (0..1).map{ Walker.new(width, height) }
	end

	# the goal here is an inverse
	# square law. hmmm. big_dist weak.
	# 1 - p kinda thing.
	# q1*q2/r^2
	Eb = 1.009.freeze
	def diff(x, y, w, z)
		force_x = smaller_diff(w,x)/Eb
		force_y = smaller_diff(z,y)/Eb
		[force_x - x, force_y - y]
	end

	def smaller_diff(x,y)
		abs(x-y) < abs(y-x) ? x-y : y-x
	end

	def counter(n=3600) ; @i = ((@i||0) + 1) % n ; end
	def abs(n) ; (n**2)**0.5 ; end 

	def spawn limit
		if @i % 10 == 0 && @walkers.count < limit
			@walkers << Walker.new(width, height)
		end
	end

	def lightning
		range = @walkers.count
		me, you = [0,1].map{ @walkers[rand(range)]}
		stroke(*me.color) ; stroke_width(1)
		vect, wect = [me.coords, you.coords]
		# line(*vect,*wect)

		# keep those that zap close.	
		mes = diff(*vect, *wect)
		yous = diff(*wect, *vect)
		me.set_coords(*mes)
		you.set_coords(*yous)
	end

	def render
		no_stroke
		@walkers.each do |walker|
			fill(*walker.color)
			size = [walker.size] * 2
			ellipse(*walker.coords,*size)
			walker.walk
		end
	end

	def draw
		# clear
		counter
		spawn 40
		render
		lightning
	end
