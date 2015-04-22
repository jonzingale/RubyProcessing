require 'matrix'
ID = Matrix.columns([[1,0,0],[0,1,0],[0,0,1]])
VECT = Vector.elements([1,2,3])
BECT = Vector.elements([4,5,6])

def setup
	size(1450,870) #HOME
	# size(1920,1080) #JackRabbit
	background(20) ; frame_rate 10
	@w,@h = [width,height].map{|i|i/2.0}
	@rand_c = (0..2).map{rand(255)} ; @i = 0
	text_font create_font("SanSerif",10) 
end

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def vects(d)
	Matrix.rows((0...2**d).map{|i|("%03d"%i.to_s(2)).split('').map(&:to_i)}) * 300
end

def draw
	@i+=0.01 ; sin,cos = trigs(@i*2*PI)
	# translate?
	rots_x = Matrix.columns([[1,0,0],[0,-sin,cos],[0,cos,sin,]])
	rots_y = Matrix.columns([[-sin,0,cos],[0,1,0],[cos,0,sin,]])
	rots_z = Matrix.columns([[-sin,cos,0],[cos,sin,0],[0,0,1]])

	no_stroke ; fill(0) ; rect(0,0,width,height)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}

	cube = vects(3).transpose
	turn = rots_x * cube

	idea = turn.transpose.to_a.map{|i|i.take(2).map(&:floor)}
	translate = idea.map{|t|t.zip([@w,@h]).map{|a,b|a+b}}

	translate.map{|t|ellipse(*t,10,10)}
	text("#{translate}",200,200)
end

# may want to figure out padding a transformation
# inclusion?