require 'matrix'
ID = Matrix.columns([[1,0,0],[0,1,0],[0,0,1]])
VECT = Vector.elements([1,2,3])
BECT = Vector.elements([4,5,6])

def setup
	size(1450,870) #HOME
	# size(1920,1080) #JackRabbit
	background(20) ; frame_rate 2
	@w,@h = [width,height].map{|i|i/2.0}
	@rand_c = (0..2).map{rand(255)} ; @i, @j, @k = [0]*3
	text_font create_font("SanSerif",10) 
end

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def vects(d)
	Matrix.rows((0...2**d).map{|i|("%0#{d}d"%i.to_s(2)).split('').map(&:to_i)}) * 300
end

def draw
	@i+=0.01 ; @j+=0.01 ; @k+=0.01
	sin1,cos1 = trigs(@i*2*PI)
	sin2,cos2 = trigs(@j*2*PI)
	sin3,cos3 = trigs(@k*2*PI) 

	rots_x = Matrix.columns([[cos1,sin1,0,0],[-sin1,cos1,0,0],[0,0,1,0],[0,0,0,1]])
	rots_y = Matrix.columns([[cos2,0,sin2,0],[0,1,0,0],[-sin2,0,cos2,0],[0,0,0,1]])
	rots_z = Matrix.columns([[cos3,0,0,sin3],[0,1,0,0],[0,0,1,0],[-sin3,0,0,cos3]])


	no_stroke ; fill(0) ; rect(0,0,width,height)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}

	hyper_cube = vects(4).transpose
	turn = rots_z * rots_y * rots_x * hyper_cube

	idea = turn.transpose.to_a.map{|i|i.take(2).map(&:floor)}
	translate = idea.map{|t|t.zip([@w,@h]).map{|a,b|a+b}}

	translate.map{|t|ellipse(*t,10,10)}
	text("#{translate}",200,200)

  translate.zip(translate.drop(1)<<translate[0]).map{|a,d| stroke(*@rand_c); line(*a,*d)}


end
