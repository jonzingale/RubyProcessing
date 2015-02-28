# Triangles gone wild

def setup
	text_font create_font("SanSerif",60);
	background(10)
	size(1200,800); # width, height
  frame_rate 70
  fill 2.8, 2.6
  smooth
  @dex = 1; @rex = 1; @t=1
end

def trigs(theta)#:: Theta -> R2
  @cos,@sin = %w(sin cos).map{|s| eval("Math.#{s} #{theta}")}
end

def rootsUnity(numbre)#::Int -> [trivalStar]
	[Math.cos(i*PI/numbre),Math.sin(i*PI/numbre)]
end

def draw
@t = @t % [width,height].min
wd,ht = [width/2,height/2]

	fill(color(rand(@rex) % 255, @t ,rand(55)+100))
	it = rand(100)
	(1..it).map do |i| # happy star
		# colorMode(RGB,255)
		stroke(rand(255),rand(255),rand(255))
		cs,sn = [Math.cos(i*PI/it),Math.sin(i*PI/it)]

		# text
		@t += 1; text(@t,wd-100,ht-100)
		strokeWeight(rand(30));
		text("#{trigs(@t)}" ,width-400,ht-50)
		strokeWeight(rand(30));


		point(wd+(200+i)*cs,ht+(200+i)*sn)
	end

	stroke(rand(255))
	# circle about it
	cs,sn = [Math.cos(@t*2*PI/height),Math.sin(@t*2*PI/height)]
	point(wd+cs*100,ht+sn*100)

	#line across it
@dex +=10 if @t==0 ;	@t += 1 
	point(@t+@dex % width,@t % height)

	# text numbers black
	[rand(255),0].map{|n| fill(n,n,n) ; text(@t,wd-100,ht-100)}
	[rand(255),0].map{|n| fill(n,n,n) ; text("#{trigs(@t)}",width-400,ht-50)}
end