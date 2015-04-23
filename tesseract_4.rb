# todo:
# faces
# clean-up and distribute.
require 'matrix'
ID = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]).freeze
HEXAGONAL = Matrix.rows([[1,0,-1,1],[0.5,1,0.5,1],[0,0,0,1],[0,0,0,1]]).freeze
PULLED = Matrix.rows([[1,0,0,1],[0,1,0,1],[0,0,0,0],[0,0,0,1]]).freeze

BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze
TRIANGLES = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }.freeze
EDGES = TRIANGLES.map{|a,b|[a,b] if BASES.include?(a^b)}.compact.freeze

def setup
	size(1450,870) #HOME
	# size(1920,1080) #JackRabbit
	background(20) ; frame_rate 100
	@w,@h = [width,height].map{|i|i/2.0-100}
	@i, @j, @k = [0]*3 ; @rand_c = (0..2).map{rand(255)} 
	text_font create_font("SanSerif",30) ; @key = nil
end

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def tranny
	sin1,cos1,sin2,cos2,sin3,cos3 = [@i,@j,@k].inject([]){|i,z|i+=trigs(z*2*PI)}
	rots_x = Matrix.columns([[cos1,sin1,0,0],[-sin1,cos1,0,0],[0,0,1,0],[0,0,0,1]])
	rots_y = Matrix.columns([[cos2,0,sin2,0],[0,1,0,0],[-sin2,0,cos2,0],[0,0,0,1]])
	rots_z = Matrix.columns([[cos3,0,0,sin3],[0,1,0,0],[0,0,1,0],[-sin3,0,0,cos3]])

	# qwerty = [82,84] # R , T
	# trans = [HEXAGONAL,PULLED]
	# tran = qwerty.zip(trans).detect{|q,t| q == @key }
	HEXAGONAL*rots_z*rots_y*rots_x
end

def draw
	@i+=0.001 ; @j+=0.001 ; @k+=0.001
	no_stroke ; fill(0) ; rect(0,0,width,height)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}

	e_coords = EDGES.map do |a|
		a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}
	end

	turn_edges = e_coords.map do |s|
		s.map{|v| (tranny * Vector.elements(v) * 150).to_a}
	end

	edges2d = turn_edges.transpose.map{|i|i.map{|j|j.take(2).map(&:floor)}}
	translate = edges2d.transpose.map{|edge|edge.map{|e| [e[0]+@w,e[1]+@h] }}
	translate.each{|edge|a,b = edge ; line(*a,*b)}
end


# xy_rotation = [[cos(t),sin(t),0,0],[-sin(t),cos(t),0 ,0],[0,0,1,0],[0,0,0,1]]
# zw_rotation = [[1,0,0,0],[0,1,0,0],[0,0,cos(t),-sin(t)],[0,0,sin(t),cos(t)]]
# zw_rotation = [[cos(t),0,-sin(t),0],[0,1,0,0],[sin(t),0,cos(t),0],[0,0,0,1]]
# yw_rotation = [[1,0,0,0],[0,cos(t),0,-sin(t)],[0,0,1,0],[0,sin(t),0,cos(t)]]
# yz_rotation = [[1,0,0,0],[ 0,cos(t),sin(t),0],[0,-sin(t),cos(t),0],[0,0,0,1]]
# xw_rotation = [[cos(t),0,0,sin(t)],[0,1,0,0],[0,0,1,0],[-sin(t),0,0,cos(t)]] 
    
	# crawler = Matrix.rows([[1,0,0,1],[0,1,0,0],[0,0,1,1],[0,0,0,1]])    