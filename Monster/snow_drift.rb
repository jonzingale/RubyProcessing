# require (File.expand_path('./snow', File.dirname(__FILE__)))
# require (File.expand_path('./poisson_process', File.dirname(__FILE__)))
# binding = $app

	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0 ; background(0)
    frame_rate 40
    preferences

		@flakes = create_flakes 3000
	end

	# all white flakes
	def preferences ; no_stroke ; fill(0,0,100,70) ; end

	def create_flakes num
		density = 4
		components, snow = Poisson.new(num, density).components, []

		components.each_with_index do |n, size|
			n.times{ snow << Snow.new(width, height, size) }
		end ; snow
	end

	def render flake
		x, y, *zs = flake.coords
		ellipse(x, y, flake.size, flake.size)
	end

	def draw ; clear
		@flakes.map do |flake|
			flake.drift
			render flake
		end
	end

class Snow # this one is slower than snow.rb
	Lambda = 7.freeze

	attr_accessor :coords, :size, :circum
	def initialize(width, height, size=nil)
		@coords = [rand(width), rand(height), 0, 0]
		@width, @height = width, height
		@size = size || 1 + rand(Lambda)
		@circum = get_circum 0.48
	end

	def get_circum den
		# @height*(0.2 + 0.8*@size /Lambda.to_f)
		@height*(den+ (1-den)*@size /Lambda.to_f)
	end

	def drift
		x, y, s, t = @coords
		@coords = [(x + trip_x(s) * 3) % @width, 
							 (y + trip_y(t) * 2) % @circum, 
							 s, t]
	end

	def trip_x(s) ; rand(20) == 1 ? (-1) ** rand(2) : s ; end
	def trip_y(t) ; rand(3) == 1 ? rand(2) : t ; end
end


class Poisson
	Epsilon = 10**-8

	attr_reader :ary, :components

	def initialize flakes, density = 3
		@density = density
		@num = flakes
		@components = ary.map{|p| (p * flakes).floor }
	end

	def fact(n) ; n=1 if n < 1 ; (1..n).inject :* ; end

	def poisson k
		num = @density**k
		denom = fact(k) * Math.exp(@density)
		num/denom.to_f
	end

	def ary # stops when values are too small
		(1..@num).take_while{|x| poisson(x) > Epsilon}.map{|k| poisson(k)}
	end

end