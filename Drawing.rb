require 'ruby-processing'
# require 'ruby-processing/app'
# jruby-1.7.19 at least in RVM
class Sketch < Processing::App



	def setup
		size(700, 700);
		fill(102);
		text_font create_font("SanSerif",30);
	end
	
	def draw
		fill 123;
		text "Hello World",5,30;
		
		line(0,500,500,0);
		fill(255);
		
		noFill();
		stroke(255, 102, 0);
		
		bezier(0, 500, 250, 0,250, 0,500, 500);
	end
end


 Sketch.new
	# k=0 #this block has no meaning in Draw.
	# while k<500
	#  ra = rand(500)
	#  rb = rand(500)
	# end 




