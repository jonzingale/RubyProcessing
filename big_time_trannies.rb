# colors orbits of various actions about finite special linear groups.

# todo: On a donut or at least center the thing.
#       what relation between @w factor and edges factor?

# 			text("#{tranny,num_classes}",@w,100)
#       spread colors, how many classes?
# 			display paths one at a time?
#       maxes out at @order = 14

require 'matrix'
ID = Matrix.columns([[1,0],[0,1]])
def setup
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.2 ; size(1400,1000) #HOME
  @order = 8

  # @transformation = orthogonal(@order).zip(special_linear(@order)).map{|o,sl|sl*o}.shuffle
  # @transformation = orthogonal(@order).shuffle
  @transformation = special_linear(@order).shuffle
	
	@w,@h = [width,height].map{|i|i/5.0}
	stroke_width(2)
end

def n_ary(n=2,x=0,ary=[])
	x==0 ? [0,0].drop(ary.count)+ary : n_ary(n,x/n,ary.unshift(x%n))
end

def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end

def vector_classes(k,m=ID,vs) ; vs.map do |v|
	it,*iterates = (1...vs.count).map{|i|((m**i)*v).map{|i|i%k} }
	iterates.take_while{|v|v!=it}.unshift(it) ; end
end

def orthogonal(p=2)
	all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)}.select{|m|m*m.transpose==ID}
end

def special_linear(p=2)
	all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)}.select{|m|(m.det)%p==1}
end

def tranny_classes(k,ts) ; ts.map do |t|
	(1...ts.count).map{|i|(t**i).map{|i|i%k} }.take_while{|t|t!=ID}.unshift(ID) ; end
end

def draw
	clear ; translate(@w,@h)
	tranny = @transformation.shift ; @transformation<<tranny
	text("#{tranny.to_a[0]}\n#{tranny.to_a[1]}",width-500,100) # 500

	# take classes of vectors and color'em
	vector_classes(@order,tranny,all_vs(@order)).map do |v_class|
		colors = (0..2).map{rand(255)} ; stroke(*colors,90)
		
		# -@order/2 is an not quite right attempt at centering the donut
		srcs = v_class.map{|v|v.map{|i|i-@order/2}}
		trgs = srcs.map{|v| (tranny*v).map{|i|(i % @order)}}
		# trgs = srcs.map{|v| (tranny*v).map{|i|(i% @order)-@order/2}}

		edges = srcs.zip(trgs).map{|a,b|(a.to_a+b.to_a).map{|i|i*40}}
		edges.each{|edge|line(*edge)}
	end
end
