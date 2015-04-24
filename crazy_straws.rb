require 'matrix'
ROOT2 = Math.sqrt(2)/2.0.freeze
BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze
HEXAGON = Matrix.rows([[1,0,-1,1],[0.5,1,0.5,1],[0,0,0,1],[0,0,0,1]]).freeze
REDUCTION = Matrix.rows([[1,0,0,0],[0,1,0,0]]).freeze
ID = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]).freeze

T = Matrix.rows([[1,0,0,ROOT2],[0,1,0,0],[0,0,1,ROOT2],[0,0,0,1]]).freeze
T_INV = Matrix.rows([[1,0,0,-ROOT2],[0,1,0,0],[0,0,1,-ROOT2],[0,0,0,1]]).freeze
def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end

def tranny
	sin,cos = trigs(@i*2*PI)
	xy_rot = Matrix.rows([[cos,sin,0,0],[-sin,cos,0,0],[0,0,1,0],[0,0,0,1]])
	xz_rot = Matrix.rows([[cos,0,-sin,0],[0,1,0,0],[sin,0,cos,0],[0,0,0,1]])
	zw_rot = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,cos,-sin],[0,0,sin,cos]])
	xw_rot = Matrix.rows([[cos,0,0,sin],[0,1,0,0],[0,0,1,0],[-sin,0,0,cos]])
	yw_rot = Matrix.rows([[1,0,0,0],[0,cos,0,-sin],[0,0,1,0],[0,sin,0,cos]])
	yz_rot = Matrix.rows([[1,0,0,0],[ 0,cos,sin,0],[0,-sin,cos,0],[0,0,0,1]])

	if @i < 30 % 60
		rots = [zw_rot,xz_rot,xy_rot,xw_rot,yw_rot,yz_rot]
		trot = (0..rand(5)).map{|i|rand(6)}.inject(ID){|id,t|id * rots[t]}
	else
		trot = ID
	end

	# rots = zw_rot * xz_rot #* xy_rot * xw_rot * yw_rot * yz_rot
	REDUCTION * T_INV * trot * HEXAGON * T
end

def setup
	size(1920,1080) ; background(20) ; frame_rate 20
	@w,@h = [width,height].map{|i|i/3.0} ; 	@i,@rand_c = [0,(0..2).map{rand(255)}]
	triangles = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }.freeze
	edges = triangles.map{|a,b|[a,b] if BASES.include?(a^b)}.compact.freeze
	@coords = edges.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
end

def draw
	@i+=0.003 ; e_ball = height/10.0
	no_stroke ; fill(0) ; rect(0,0,width,height)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}
	turn_edges = @coords.map{|s|s.map{|v| (tranny*Vector.elements(v)*e_ball).to_a}}
	translate = turn_edges.map{|edge|edge.map{|d,e| [d+@w,e+@h]} }
	translate.each{|edge|a,b = edge ; line(*a,*b)}
end
