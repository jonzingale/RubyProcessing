# require 'byebug'
require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./lorenz', File.dirname(__FILE__)))

class Monster
	attr_reader :beziers, :thickness, :color

	def initialize x_coord, y_coord, legs=4, thickness=40, input_dyn=nil
		@color = [rand(360), 30, 80, 70] # better this
		@w, @h = x_coord, y_coord
		@thickness = thickness
		@legs = legs
		get_beziers

		# So that each can dance about its own.
		@attractor = input_dyn || Lorenz.new
	end

	def set_feet inc
		[100*inc+ @w/2.8, rand(150)+@h+40]
	end

	def dynamics
		@attractor.blink
		# gentle_giants
		x = @attractor.x * 10 + @w/1.0
		y = @attractor.z * 10 + @h/3.0

		# beasts
		# x = @attractor.x * 10 + @w/1.0
		# y = @attractor.y * 10 + @h/3.0
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

# it = Monster.new(3, 12)
# puts it.beziers.map{|b|b.points}

# byebug ; 4