def setup
	size(1450,870) #HOME
	# size(1920,1080) #JackRabbit
	background(20) ; frame_rate 1
	@w,@h = [width,height].map{|i|i/2.0}
	@rand_c = (0..2).map{rand(255)}
	text_font create_font("SanSerif",25) ; @i = 0
end

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ;(0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def movement(vs)
	vs.zip(@rand).map{|a,b| [a[0]+b[0],a[1]+b[1]]}
end

def vert(d)
	verts = movement(rootsUnity(8).map{|l,r| [l*d+@w,r*d+@h] })
	fill(*@rand_c) ; verts.map{ |v| ellipse(*v,10,10) } ; verts
end

def edges(d,t)
	perm = vert(d).drop(t)+vert(d).take(t)
	vert(d).zip(perm).map{|a,d| stroke(*@rand_c); line(*a,*d)}
end

def draw
	@rand = (0..16).map{[rand(200)-100,rand(200)-100]}
	no_stroke ; fill(0) ; rect(0,0,width,height)

	[100,300].map{|v|vert(v)} ; [[100,3],[300,1]].map{|e|edges(*e)}

	ary = [-1,1].inject([]){|a,j| a+=(0..7).map{|i| vert(100)[(i-j)%8]} }
	(vert(300)*2).zip(ary).map{|a,d| stroke(*@rand_c); line(*a,*d)}
end
