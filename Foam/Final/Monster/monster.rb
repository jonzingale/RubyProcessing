require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./lorenz', File.dirname(__FILE__)))

class Monster
	attr_reader :beziers, :thickness, :color

	def initialize x_coord, y_coord, legs=4, thickness=40, input_dyn=nil
		# 199:209 purple, 342:301 red, 139 blue, 6 red/green
		color = [199,209,342,301,139][rand 5]
		@color = [color, 30, 80, 80]
		@w, @h = x_coord*1.4, y_coord
		@thickness = thickness
		@legs = legs
		get_beziers

		# for the monster to bob about.
		@attractor = input_dyn || Lorenz.new
	end

	def set_feet inc
		[100*inc+ @w/2.8, rand(150)+@h+40]
	end

	def dynamics
		@attractor.blink

		# gentle_giants
		# x = @attractor.x * 7 + @w/1.0
		# y = @attractor.z * 7 + @h/3.0

		# beasts
		x = @attractor.x * 10 + @w/1.0
		y = @attractor.y * 10 + @h/3.0
		@beziers.map{|bezier| bezier.coords([x,y])}
	end

	def get_beziers
		@beziers = (1..@legs).map do |inc|
			points = [[0,@h], [@w, rand(30)], set_feet(inc)]
			Bezier.new(points)
		end
	end
end


# TODO: HOW DO I GET THE NECK FURTHER OUT? 


# it = Monster.new(3, 12)
# puts it.beziers.map{|b|b.points}

# require 'byebug' ; byebug ; 4