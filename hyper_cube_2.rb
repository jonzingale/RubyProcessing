require 'matrix'
# this version has trails!
BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze
REDUCED_HEX = Matrix.rows([[1.0, 0, -1.0, 1], [0.5, 1, 0.5, 1]]).freeze
def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end

def tranny
	sin,cos = trigs(@i*2*PI)
	xy_rot = Matrix.rows([[cos,sin,0,0],[-sin,cos,0,0],[0,0,1,0],[0,0,0,1]])
	xz_rot = Matrix.rows([[cos,0,-sin,0],[0,1,0,0],[sin,0,cos,0],[0,0,0,1]])
	zw_rot = Matrix.rows([[1,0,0,0],[0,1,0,0],[0,0,cos,-sin],[0,0,sin,cos]])
	REDUCED_HEX * zw_rot * xz_rot * xy_rot
end

def setup
	@loaded = loadImage("/Users/Jon/Desktop/test.png")
	size(1920,1080) ; background(20) ; frame_rate 20
	@w,@h = [width,height].map{|i|i/3.0} ; 	@i,@rand_c = [0,(0..2).map{rand(255)}]
	triangles = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }.freeze
	edges = triangles.map{|a,b|[a,b] if BASES.include?(a^b)}.compact.freeze
	@coords = edges.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
end

def images
	if @i == 0
		save('/Users/Jon/Desktop/test.png')
		@loaded = loadImage("/Users/Jon/Desktop/test.png")
	else ; image(@loaded,0,0) ; end
end

def draw
	images ; @i+=0.003
	# no_stroke ; fill(0) ; rect(0,0,width,height)
	strokeWeight(1)
	[:fill,:stroke].each{|f|send(f,*@rand_c)}
	turn_edges = @coords.map{|s|s.map{|v| (tranny*Vector.elements(v)* 200).to_a}}
	translate = turn_edges.map{|edge|edge.map{|d,e| [d+@w,e+@h]} }
	translate.each{|edge|a,b = edge ; line(*a,*b)}
# before
	@loaded = get(0,0,width,height)
# after
	rand_c = (0..2).map{rand(255)}
	[:fill,:stroke].each{|f|send(f,*rand_c)} ; strokeWeight(3)
	translate.each{|edge|a,b = edge ; line(*a,*b)}
end
