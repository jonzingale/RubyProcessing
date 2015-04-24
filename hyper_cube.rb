require 'matrix'
# pretty sweet where it is.
BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze

ID = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]).freeze
HEXAGON = Matrix.rows([[1,0,-1,1],[0.5,1,0.5,1],[0,0,0,1],[0,0,0,1]]).freeze
INCL = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[0,0,0,1]]).freeze
REDUCTION = Matrix.rows([[1,0,0,0],[0,1,0,0]]).freeze

# Attempts at translating. I think I need a 5x5 to translate correctly
# how do I rewrite the flow then so all dimensions work out?
EXP_HEX = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]).freeze
ROOT2 = Math.sqrt(2)/2.0.freeze
T = Matrix.rows([[1,0,0,ROOT2],[0,1,0,ROOT2],[0,0,1,ROOT2],[0,0,0,1]]).freeze
T_INV = Matrix.rows([[1,0,0,-ROOT2],[0,1,0,-ROOT2],[0,0,1,-ROOT2],[0,0,0,1]]).freeze
def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end

def tranny
	sin,cos = trigs(@i*2*PI)
	xy_rot = Matrix.rows([[cos,sin,0,0],[-sin,cos,0,0],[0,0,1,0],[0,0,0,1]])
	xz_rot = Matrix.rows([[cos,0,-sin,0],[0,1,0,0],[sin,0,cos,0],[0,0,0,1]])
	yw_rot = Matrix.rows([[1,0,0,0],[0,cos,0,-sin],[0,0,1,0],[0,sin,0,cos]])
	# zw_rot = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,cos,-sin],[0,0,sin,cos]])
	# xw_rot = Matrix.rows([[cos,0,0,sin],[0,1,0,0],[0,0,1,0],[-sin,0,0,cos]])
	# yz_rot = Matrix.rows([[1,0,0,0],[ 0,cos,sin,0],[0,-sin,cos,0],[0,0,0,1]])

	# REDUCTION * T * yw_rot * xz_rot * xy_rot * T_INV * EXP_HEX # gives a great perspective
	REDUCTION * yw_rot * xz_rot * xy_rot * EXP_HEX # gives the perspective I want.
end

def setup
	size(1920,1080) ; background(20) ; frame_rate 20
	@w,@h = [width,height].map{|i|i/2.0} ; 	@i,@rand_c = [0,(0..2).map{rand(255)}]
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
