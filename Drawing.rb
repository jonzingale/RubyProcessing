require 'ruby-processing'
# jruby-1.7.19 at least in RVM
class Sketch < Processing::App

	def setup
		text_font create_font("SanSerif",40);
		@img = loadImage("/Users/Jon/Desktop/crude/Ruby/data/colorwheel.png");
		@img.loadPixels()
		background(20)
		# width, height
		size(1920,1080) #JackRabbit
		# size(1600,1000) #HOME
		frame_rate 3
		@t = -1; @s = -1 ; @i = 0
  	smooth ; @m = [0,0]
	end

# write a f :: (a,a)->(a->b)->(b,b)
# maybe a diag function or something
	def unzip(as=[],ls=[],rs=[])
		a,*bs = as ; a,b = a
		as.empty? ? [ls,rs] : unzip(bs,ls<<a,rs<<b)
	end

	def trigs(theta)#:: Theta -> R2
		@cos,@sin = %w(sin cos).map{|s| Math.send(s,theta)}
	end

	def rootsUnity(n)#::Int -> [Star]
		(0...n).map{|i| %w(sin cos).map{|s| Math.send(s,2*PI*i/n)}}
	end

	def fact(n) (1..n).inject(1) {|r,i| r*i } end
	#1.upto(26) {|i| p [i, Math.gamma(i), fact(i-1)] }

	# P0 k k k k P1 k k k k P2
	def poisson(lambda,pts,k) # density, points, grain
		k = k * pts
		Math.exp(lambda) * (0...k).inject(0) do |s,k|
			s + ((lambda ** k) / fact(k))
		end
	end

	def draw # modular_indices
		# image(@img, 100, height-600);
		@s = (@s+=1) % width
		@t = (@t+=1) % height
		col  = @s % 256
		cos,sin = trigs(@s*100)
		x,y = [width/2,height/2]


######sample a color
		@m = get(mouseX,mouseY)
		r1 = 256 + @m/(256**2)
		g1 = @m/256 % 256
		b1 = @m % 256
		fill(r1,g1,b1)
		ellipse(x+200,y,200,200);

		rect(300,0,300,100);
		fill(0);
		fill(255,0,0);
		text("#{r1}  #{g1}  #{b1}", 100,100);

#### playback a color
		allcolors = 256**3
		unit = ((@s/10000.to_f)*mouseX/width.to_f)*allcolors
		r2 = 256 + unit/(256**2)
		g2 = unit/256 % 256
		b2 = unit % 256
		fill(r2,g2,b2)
		ellipse(x,y,200,200);

		rect(100,200,200,300);
		fill(0);
		fill(255,255,0);
		text("#{(mouseX.to_f/width.to_f)*allcolors}", 100,200);
########
		# * :: [a] -> Params(a) # x,y's matter, keep'em clean
		roots = rootsUnity(4).inject([]){|rs,p|i,j=p;rs+[(i*100)+x,y+(j*100)]}
		randos = (1..3).map{|i|rand(255)}
		strokeWeight(0.3); fill(*randos)
		bezier(*roots)#.shuffle) 

		# color wheel
		subsets = (0..7).map{|i|'%03d' % (i.to_s(2).to_i)}
		subsets = [[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
		colors = subsets.map{|s|r,g,b = s ; [r*255,g*255,b*255]}
		colors.zip(rootsUnity(8)).map do |c_p|
			c,ps = c_p ; p,q = ps ; r,b,g = c
			fill(r,b,g)
			ellipse((p*200)+x,(q*200)+y,100,100)
			fill(90)
		end
	end
end


 Sketch.new
