# todo: faces, translate off of vertex
require 'matrix'
ROOT2 = Math.sqrt(2)/2.0
BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze
TRIANGLES = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }.freeze
EDGES = TRIANGLES.map{|a,b|[a,b] if BASES.include?(a^b)}.compact.freeze
EDGE_COORDS = EDGES.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
HEXAGON = Matrix.rows([[1,0,-1,1],[0.5,1,0.5,1],[0,0,0,1],[0,0,0,1]]).freeze
# Can I modify Edges by Hexagon here?

TRANSLATE = Matrix.rows([[1,0,0,1],[0,1,0,0],[0,0,1,1],[0,0,0,1]])
UNTRANSLATE = Matrix.rows([[1,0,0,-1],[0,1,0,0],[0,0,1,-1],[0,0,0,1]])

REDUCTION = Matrix.rows([[1,0,0,0],[0,1,0,0]]).freeze
def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end

def setup
	background(20) ; frame_rate 30
	size(1400,1080) #HOME
	# size(1920,1080)
	@w,@h = [width,height].map{|i|i/2.0} ; 	@i = 0
	@rand_c = (0..2).map{rand(255)}
end

def tranny
	sin,cos = trigs(@i*2*PI)
	xy_rot = Matrix.rows([[cos,sin,0,0],[-sin,cos,0,0],[0,0,1,0],[0,0,0,1]])
	xz_rot = Matrix.rows([[cos,0,-sin,0],[0,1,0,0],[sin,0,cos,0],[0,0,0,1]])
	# zw_rot = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,cos,-sin],[0,0,sin,cos]])
	# xw_rot = Matrix.rows([[cos,0,0,sin],[0,1,0,0],[0,0,1,0],[-sin,0,0,cos]])
	yw_rot = Matrix.rows([[1,0,0,0],[0,cos,0,-sin],[0,0,1,0],[0,sin,0,cos]])
	# yz_rot = Matrix.rows([[1,0,0,0],[ 0,cos,sin,0],[0,-sin,cos,0],[0,0,0,1]])

	# how do i get the translate to work?
	REDUCTION * yw_rot * xz_rot * xy_rot * HEXAGON
end

def draw
	@i+=0.003
	no_stroke ; fill(0) ; rect(0,0,width,height)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}

	# Can I make e_coords a matrix instead of passing individual Vectors?
	turn_edges = EDGE_COORDS.map{|s|s.map{|v| (tranny*Vector.elements(v)* 100).to_a}}

	translate = turn_edges.map{|edge|edge.map{|d,e| [d+@w,e+@h]} }
	translate.each{|edge|a,b = edge ; line(*a,*b)}
end
  