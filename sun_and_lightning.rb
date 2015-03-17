# Spirals cause Jake asked for them.
R = 100.freeze

def setup
	text_font create_font("SanSerif",60);
	background(10)
	# width, height
	# size(1920,1080) #JackRabbit
	size(1500,900) #HOME
  frame_rate 20
  fill 2.8, 2.6
  smooth
  @t=1 ; @i = 0
end

def unzip(as=[],ls=[],rs=[]) # really just transpose
	a,*bs = as ; a,b = a
	as.empty? ? [ls,rs] : unzip(bs,ls<<a,rs<<b)
end

def trigs(theta)#:: Theta -> R2
	@cos,@sin = %w(sin cos).map{|s| Math.send(s,theta)}
end

def rootsUnity(n)#::Int -> [Star]
	(0...n).map{|i| %w(sin cos).map{|s| Math.send(s,2*PI*i/n)}}
end

def about_center(ps,amp=1,amq=1,p=0,q=0)
	x,y = [width/2,height/2] # center point
	a,b = ps ; [(a*amp)+(p+x),(b*amq)+(q+y)]
end

def args2pairs(a=[])
	xs = a.select{|i|a.index(i)%2 == 1}
	ys = a.select{|i|a.index(i)%2 == 0}
	xs.zip(ys)
end

def eachPair(ps,fs) #:: [(x,y)] -> (f,g) -> [(fx,gy)]
	xs,ys = unzip(ps) ; f,g = fs
	[xs.map{|x| x.send(f.to_sym)}, 
	 ys.map{|y| y.send(g.to_sym)}]
end

def draw
	x,y = [width/2,height/2] # center point
	g,b = [@t*2,@t*2.1] #greens blues
	@t = (@t+=1) % width # modular_index
	cos,sin = trigs(@t)


tit = rand(40)
fill(255,90,0,30)
ellipse(200,200,tit*10,tit*10)


###bezier land
	r = rand(30) + @t
	g = rand(255*@cos)
	b = rand(255*@sin)
	fill(r,g,b) ; strokeWeight(0.3) ; stroke((r*g*b)%255)

	roots = rootsUnity(4).map{|p|about_center(p,300,300,0,-200)}.shuffle.flatten
	#use pop and shift?

	x_bs,y_bs = unzip(args2pairs(roots))
	#bezier(*roots)

	#cheetoz
	#fill(200); steps = 39.0;
	#(0..10).map do |i|
	#  t = i.to_f / steps
	#  xs = x_bs+[t]
	#  ys = y_bs+[t]
	#  a = bezierPoint(*xs);
	#  b = bezierPoint(*ys);

	#  ellipse(a*@cos, b*@cos, 90, 30);

	# spidery-web
	fill(649); steps = 39.0;
	(0..10).map do |i|
	 t = i.to_f / steps
	 xs = x_bs+[t]
	 ys = y_bs+[t]
	 a = bezierPoint(*xs);
	 b = bezierPoint(*ys);
	 stroke(rand(255)*@sin,rand(255)*@cos,120,rand(10)+230)
	 strokeWeight(rand(3))
	 ellipse(x+a*@sin, b*@cos, 90, 30);	  
	end

lit = rand(100)
boots = [x,0,rand(width),rand(height),rand(width),rand(height),x,height]
noFill; stroke(rand(5)+lit,rand(30)+lit,rand(255),220)
bezier(*boots)
	#targets
	# fill(649); steps = 39.0;
	# (0..10).map do |i|
	#   t = i.to_f / steps
	#   xs = x_bs+[t]
	#   ys = y_bs+[t]
	#   a = bezierPoint(*xs);
	#   b = bezierPoint(*ys);

	#   # ellipse(a*@cos*16, b*@cos, 90, 30);	  
	# end
end



