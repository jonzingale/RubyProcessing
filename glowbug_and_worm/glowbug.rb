	class Glowbug

		def initialize(points)
			@points = points
			@i = 1
		end

		def value ; @points ; end

		def walk(width,height)
			walk_cond = (@i = (1 + @i) % 3) == 0

			if walk_cond
				r, s = (0..1).map{rand(3) - 1}.map{|rnd| rnd * 8}
				x, y = @points
				@points = [(x+r)%width,(y+s)%height]
			else
				@points
			end
		end

	end
