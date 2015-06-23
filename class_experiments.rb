require 'ruby-processing'

class Sketch < Processing::App
	def setup
		size(500, 500)
		frame_rate 20
		text_font create_font("SanSerif",30)
		color_mode HSB, 360
		@i = 0, @sat = 120
	end
	
	def draw
		line(0,500,500,0) ;# @i += 1
		colors = (0..2).map{ rand(200) }
		@sat += (@sat + rand(40) % 360)
		fill(120,@sat,100)
		
		stroke(255, 102, 0)
		bezier(0, 500, 250, 0,250, 0,500, 500)
		
		Bitches.no_loop

		line(0,0,120,120)
		stroke(120%256)
		
		ellipse mouse_x, mouse_y, 100, 100
	end
end

class Bitches < Processing::App
	def self.no_loop
		# if @i > 200
			# ellipse 200, 299, 100, 100
		# end
	end
end



Sketch.new





