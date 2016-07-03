# Spirals cause Jake asked for them.
R = 100.freeze

def setup
	text_font create_font("SanSerif",60);
	size(displayWidth, displayHeight)
	background(10)
  frame_rate 20
  fill 2.8, 2.6
  smooth
  @t, @i = 1, 0 ; @dex = 1; @rex = 1
end

def trigs(theta)#:: Theta -> R2
  @cos,@sin = %w(sin cos).map{|s| eval("Math.#{s} #{theta}")}
end

def rootsUnity(numbre)#::Int -> [trivalStar]
	(0..numbre-1).map{|i|[Math.cos(i*PI/numbre),Math.sin(i*PI/numbre)]}
end

def diff(w)#::(Coord,Coord)->(Coord,Coord)-> (N,N)
	w1,w2 = w ; a,b = w1 ; c,d = w2
	[a-c,b-d].map(&:abs)
end

def walker_y(t,a=0) # index->attraction->point
	kick = [0,0,0,200] ; snare = (1..3).map{|i|rand(255)}+[rand(100)]
 [kick,snare].map do |b|
 		s1,s2,s3,w = b ; stroke(s1,s2,s3,w) ; strokeWeight(w)

 		pair = [[-@t%width,height/2],[@t+a,(@t+a)/3]]
 		pair2 = [[@t%width,-height/2],[@t+a,(@t+a)/3]]
 		closer = [diff(pair),diff(pair2)].min
 		farther = [diff(pair),diff(pair2)].max

 		p,q = (a%height < 10 ? farther : a%height > 100 ? closer : nil)
 		point(@t+p,(@t+q)/3)
 end
end

def walker_x(t,a=0)
	kick = [0,0,0,40] ; snare = (1..3).map{|i|rand(255)}+[rand(30)]
 [kick,snare].map do |b|
 		s1,s2,s3,w = b ; stroke(s1,s2,s3,w) ; strokeWeight(w)
 		
 		pair = [[-@t%width,height/2],[@t+a,(@t+a)/3]] 		
 		pair2 = [[@t%width,-height/2],[@t+a,(@t+a)/3]] 		
 		closer = [diff(pair),diff(pair2)].min 		
 		farther = [diff(pair),diff(pair2)].max
 		p,q = (a%height < 10 ? farther : a%height > 100 ? closer : nil)
 		point(p,q)

 		point(-@t%width,height/2)
 end
end

def draw
	x,y = [width/2,height/2] # center point
	g,b = [@t*2,@t*2.1] #greens blues
	@t = (@t+=1) % width # modular_index
	cos,sin = trigs(@t)

	# two dots get near, attract and then repel
	walker_y(@t) ; walker_x(@t)

###bezier land
	r = rand(30) + @t
	g = rand(200*@cos)
	b = rand(300*@sin)
	stroke(r,g,b)

	roots = rootsUnity(5).shuffle
	b_points = roots.inject([]){|js,i| js+i }
	a,b,c,d,e,f,g,h = b_points.shuffle
	bezier(a,b,c,d,e,f,g,h);

		# line coods
		strokeWeight(1)
		r,t = [a,c].map{|i| height - i*rand(500)}
		q,s = [b,d].map{|i| i*rand(800)}
		line(q,r,s,t)
# ###bezier

	if @i < 2000 then @i+=1 else
		fill(100,100,100,100)
		text_font create_font("SanSerif",200);
		text("Donald" ,rand(@cos)+x-200,rand(@sin)+y-200 )
		strokeWeight(rand(30));
		text("Michael" ,x+@cos*@t,@t*R*@sin+x-rand(300))
		text('ZER0',width - 400,height - (y/4))
	end

	#########
	wd,ht = [width/2,height/2]
	fill(color(rand(@rex) % 255, @t ,rand(55)+100))

	it = rand(100)
	(1..it).map do |i| # happy star
		# colorMode(RGB,255)
		stroke(rand(255),rand(255),rand(255))
		cs,sn = [Math.cos(i*PI/it),Math.sin(i*PI/it)]
		@t += 1; text(@t,wd-100,ht-100)
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

end