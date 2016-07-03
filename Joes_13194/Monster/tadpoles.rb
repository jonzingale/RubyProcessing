# a self contained file for Foam.

class Bezier
	attr_reader :points
	def initialize(points)
		@points = points
		@count = points.count - 1
	end

	def coords(coords) ; @points = [coords] + @points.drop(1) ; end 

	def plot(time) # Sigma (1-t)^k * t^(n-k) * Pk
		scalars = (0..@count).map{|k| (1-time)**k * time**(@count-k) }
		it = @points.zip(scalars).map{|pts,s| pts.map{|xs| xs*s}}
		it.transpose.map{|i| i.inject :+}
	end
end

class Lorenz
	Eball = 0.004
	attr_reader :x, :y, :z, :color
	def initialize(x=nil, y=nil, z=nil, color=nil)
		@color = color || [rand(360), 80, 90, 70]
		@x = x||rand(18) # -18 < x <18
		@y = y||rand(24) # -24 < y < 24
		@z = z||rand(45) # 4 < z < 45
	end

	def dx ; 10 * (@y - @x) ; end
	def dy ; @x * (28 - @z) - @y ; end
	def dz ; @x * @y - @z * 8 / 3.0  ; end

	def blink
		[@x = Eball*dx + @x,
		 @y = Eball*dy + @y,
		 @z = Eball*dz + @z]
	end
end

class Monster
	attr_reader :beziers, :thickness, :color

	def initialize x_coord, y_coord, legs=4, thickness=40, input_dyn=nil
		@color = [100+rand(150), 30, 80, 70] # better this
		@w, @h = [x_coord, y_coord]
		@thickness = thickness
		@legs = legs
		get_beziers

		# So that each can dance about its own.
		@attractor = input_dyn || Lorenz.new
	end

	def set_feet inc
		[100*inc+ @w, rand(150)+@h]
	end

	def dynamics
		@attractor.blink
		x = @attractor.x * 10 + @w/1.2
		y = @attractor.y * 5 + @h/1.3
		# changes points here.
		@beziers.map{|bezier| bezier.coords([x,y])}
	end

	def get_beziers
		@beziers = (1..@legs).map do |inc|
			points = [[0,@h], [@w, rand(30)], set_feet(inc)]
			Bezier.new(points)
		end
	end
end

	RES = 40.0.freeze

	def setup
		text_font create_font("SanSerif",50)
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 30
		background(0)
		no_stroke

		@monsters = create_monsters 300
	end

	def create_monsters num
		(1..num).map do |i|
			Monster.new(rand(width), rand(height), 5, 10)
		end
	end

	def render_lorenz monster
		monster.beziers.each do |bezier|
			pts = bezier.points[0]
			color = monster.color[0,3]+[100]
			fill(*color) ; ellipse(*pts,2,2)
		end
	end

	def draw #; clear
		fill(0,0,0,12)
		rect(0,0,width,height)
		@monsters.map do |monster| 
			monster.dynamics
			render_lorenz monster
		end
	end