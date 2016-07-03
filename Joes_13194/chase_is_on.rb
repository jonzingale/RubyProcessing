# Spirals cause Jake asked for them.
R = 100.freeze

def setup
	text_font create_font("SanSerif",60);
	size(displayWidth, displayHeight)
	background(10)
  frame_rate 30
  fill 2.8, 2.6
  smooth
  @t, @i = 1, 0
end

def trigs(theta)#:: Theta -> R2
  @cos,@sin = %w(sin cos).map{|s| eval("Math.#{s} #{theta}")}
end

def rootsUnity(numbre)#::Int -> [trivalStar]
	(0..numbre-1).map{|i|[Math.cos(i*PI/numbre),Math.sin(i*PI/numbre)]}
end

def diff(w)#::(Coord,Coord)->(Coord,Coord)-> Real
	w1,w2 = w ; a,b = w1 ; c,d = w2
	x = (c-a)**2 ; y = (d-b)**2
	Math.sqrt(x+y)
end

def walker_y(t,p=width/2,q=height/2) # Follower
	kick = [0,0,0,80] ; snare = (1..3).map{|i|rand(255)}+[rand(60)+10]
 	[snare,kick,snare,snare,snare].map do |b|
 		s1,s2,s3,w = b ; stroke(s1,s2,s3,w) ; strokeWeight(w)

		signs =  [[1,1],[-1,-1],[-1,1],[1,-1]]
		p , q = (@wy1.nil? ? [p,q] : [@wy1,@wy2])
		pair2 = (@wx1.nil? ? [6,0] : [@wx1,@wx2])

		pairs = signs.map{|s| i,j=s;[[i+p,j+q],pair2] }
		min_p = pairs.min_by{|p|diff(p)}[0]
		max_p = pairs.max_by{|p|diff(p)}[0]

		p,q = (min_p[0] <= 10 ? max_p : max_p[0] >= 60 ? min_p : max_p)
 		point(@wy1=p,@wy2=q)
 	end
end

def walker_x(t,p=width/4,q=height/2) # Leader
	kick = [0,0,0,40] ; snare = (1..3).map{|i|rand(255)}+[rand(30)]
  [snare,kick,snare,snare,snare].map do |b|
 		s1,s2,s3,w = b ; stroke(s1,s2,s3,w) ; strokeWeight(w)

		signs =  [[1,1],[-1,-1],[-1,1],[1,-1]]
		pair1 = (@wy1.nil? ? [50,0]: [@wy1,@wy2])
		p , q = (@wx1.nil? ? [p,q]  : [@wx1,@wx2])

		pairs = signs.map{|s| i,j=s;[pair1,[i+p,j+q]] }
		min_p = pairs.min_by{|p|diff(p)}[1]
		max_p = pairs.max_by{|p|diff(p)}[1]

		# to keep this guy ahead
 		point(@wx1=(p+(5*rand-0.5))%width,@wx2=(q+(5*rand-0.5))%height)
 	end
end

def draw
	x,y = [width/2,height/2] # center point
	g,b = [@t*2,@t*2.1] #greens blues
	@t = (@t+=1) % width # modular_index
	cos,sin = trigs(@t)

# two dots get near, attract and then repel
	walker_y(@t) ; walker_x(@t)
###

###bezier land
	r = rand(30) + @t
	g = rand(200*@cos)
	b = rand(300*@sin)
	stroke(r,g,b)

	roots = rootsUnity(6).shuffle
	b_points = roots.inject([]){|js,i| js+i }

	strokeWeight(0.5) # quiet reds
	a,b,c,d,e,f,g,h = b_points.shuffle.map{|i|y-400*i}
	bezier(a,b,c,d,e,f,g,h)

	strokeWeight(2.2)
	a,b,c,d,e,f,g,h = b_points.map{|i|400*i}
	bezier(a,b,e,f,c,d,g,h)

	# line coods
	r,t = [a,c].map{|i| height - i*rand(300)}
	q,s = [b,d].map{|i| i*rand(800)}
	line(q,r,s,t)

	if @i < 3000 then (@i += 1) else
		good3 = [a+width/3, 500, 250+width/3,b,250+width/3, 0,e,500+width/3]
		b_points = good3.map{|d|d+width/3}
		a,b,c,d,e,f,g,h = b_points.shuffle
		bezier(a,b,c,d,e,f,g,h)
	end
# ###
end





