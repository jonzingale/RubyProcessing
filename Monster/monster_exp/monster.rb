require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./lorenz', File.dirname(__FILE__)))

class Monster
	attr_reader :beziers, :thickness, :color, :attractor

	def initialize x_coord, y_coord, legs=4, thickness=40, input_dyn=nil
		# 199:209 purple, 342:301 red, 139 blue, 6 red/green
		color = [199,209,342,301,139,6][rand 6]
		@color = [color, 30, 80, 80]
		@w, @h = x_coord, y_coord
		@thickness = thickness
		@legs = legs
		get_beziers

		# for the monster to bob about.
		@attractor = input_dyn || Lorenz.new
	end

	def set_feet(inc) ; [@w+100*inc, @h+rand(100)] ; end

	def dynamics
		@attractor.blink
		# @attractor.centered_coords # not likely necessary
	end

	def coords ; @attractor.centered_coords ; end


	def get_beziers
		@beziers = (1..@legs).map do |inc|
			points = [[0,@h], [@w, rand(30)], set_feet(inc)]
			Bezier.new(points)
		end
	end
end