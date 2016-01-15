require 'matrix'
BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
ALL_POINTS = (0...2**4).inject([],:<<).freeze

def setup
  background(20) ; frame_rate 10 ;	size(1400,1080)
	@w, @h, @i = [width,height].map{|i|i/3.0}<<0
	triangles = ALL_POINTS.inject([]){ |a,i| a+=(0...i).map{ |j| [i,j] } }.freeze
	edges = triangles.map{|a,b|[a,b] if BASES.include?(a^b)}.compact.freeze
	@coords = edges.map{|a|a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}}
	@s,@t = [[@w,@h],[@w,@h]] ; @rand = 0
end

def draw
	clear ; cos,sin = %w(cos sin).map{|s| eval("Math.#{s} #{(@i+=0.001)*2*PI}")}
	rotation = Matrix.rows([[cos**2,cos*sin,-sin,0],[-cos*sin,cos**2,0,-sin]])
	@rand += (rand(2)-1)/4.0 ; translate(@w/8.0,@h/8.0)

	transform_edges = [0,1].map do |i|
		(rotation*Matrix.columns(@coords.transpose[i])* height/5.0).transpose.to_a
	end.transpose

	#####
	colorMode(HSB,360,100,100)
	colors = [(720*@i)%360,90,100,97]
	stroke(*colors) ; no_fill
	stroke_width(3)

	transform_edges.each do |edge|
		a,b = edge.map{|d,e| [d+@w,e+@h]}
		mid_vals = [a.map{|i|i+(rand(20)-10)},b.map{|j|j+(rand(20)-10)}].flatten
		coords = [*a,*mid_vals,*b]
		bezier(*coords)
	end
	
	######
	colorMode(RGB,255,255,255)
	rand_c = (0..2).map{rand(25)+100}<<90
	stroke(*rand_c) ; no_fill
	stroke_width(3)

	transform_edges.each{|edge|a,b = edge.map{|d,e| [d+@w,e+@h]} ; line(*a,*b)}
end





# beziers @i,@j variation
# text(@i)