def setup
	size(1450,870) #HOME
	# size(1920,1080) #JackRabbit
	background(20) ; frame_rate 1
	@w,@h = [width,height].map{|i|i/2.0}
	@rand_c = (0..2).map{rand(255)}
end

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def vert(d) ; rootsUnity(16).map{|l,r| [l*d+@w,r*d+@h] } ; end
def edges(d,t) ; v = vert(d) ; v.zip(v.drop(t)+v.take(t)) ; end

def draw
	[:fill,:stroke].each{|f|send(f,*@rand_c)}
	vert(300).map{|v| ellipse(*v,10,10) }
	(edges(300,4)+edges(300,1)).map{|a,d| line(*a,*d)}
end
