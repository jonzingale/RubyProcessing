# pushes till far and away bubbles.

class Walker
	attr_reader :color, :size, :coords
	def initialize(width, height)
		# @color = [rand(60)+150, rand(100), rand(30)+70, rand(70) + 30]
		@color = [rand(360), rand(100), rand(30)+70, rand(70) + 30]
		@width, @height = width, height
		@coords = rand(width), rand(height)
		@size = rand(10) + 1
	end

	def set_coords(x, y) ; @coords = x, y ; end

	def walk
		x, y = self.coords.map{|v| v + 1 * (rand(3) - 1) }
		@coords = x % @width, y % @height
	end
end

	def setup
		size(displayWidth, displayHeight-45)
		colorMode(HSB,360,100,100,100)
		background(0) ; frame_rate 40
	  text_font create_font("SanSerif",10)

	  @walkers = (0..1).map{ Walker.new(width, height) }
	end

	Eb = 6.3.freeze
	def diff(x, y, w, z)
		small_x = smaller_diff(x,w,@width)
		small_y = smaller_diff(y,z,@height)
		force_x = x - non_zero(@width, small_x)
		force_y = y - non_zero(@height, small_y)
		[force_x, force_y]
	end

	def abs(n) ; (n**2)**0.5 ; end
	def non_zero(dim, x) ; abs(x) < 0.1 ? 0 : (x.to_f * Eb)/dim.to_f ; end
	def smaller_diff(x,w,dim) ; abs(x-w) < abs(x-(w-dim)) ? x-w : x-(w-dim) ; end
	def counter(n=3600) ; @i = ((@i||0) + 1) % n ; end

	def spawn limit
		if @i % 10 == 0 && @walkers.count < limit
			@walkers << Walker.new(width, height)
		end
	end

	def lightning
		range = @walkers.count
		me, you = [0,1].map{ @walkers[rand(range)]}
		stroke(*me.color) ; stroke_width(0.2)
		vect, wect = [me.coords, you.coords]
		line(*vect,*wect)

		# keep those that zap close.	
		mes = diff(*vect, *wect)
		yous = diff(*wect, *vect)
		me.set_coords(*mes)
		you.set_coords(*yous)
	end

	def render
		no_stroke
		@walkers.each do |walker|
			walker.walk
			fill(*walker.color)
			size = [walker.size] * 2
			ellipse(*walker.coords, *size)
		end
	end

	def draw
		# clear
		fill(0,0,0,1) ; rect(0,0,@width,@height)
		counter
		spawn 200
		render
		lightning
	end
