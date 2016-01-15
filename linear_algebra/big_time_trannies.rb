# colors orbits of various R-Mod actions  
# of finite special linear groups.
require 'matrix'
ID = Matrix.columns([[1,0],[0,1]])
def setup
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.5 ; size(1400,1000) #HOME
  @order = 5

  # @transformation = orthogonal(@order).shuffle
  @transformation = special_linear(@order).shuffle

	@w,@h = [width,height].map{|i|i/5.0}
	stroke_width(3)
end

def n_ary(n=2,x=0,ary=[])
	x==0 ? [0,0].drop(ary.count)+ary : n_ary(n,x/n,ary.unshift(x%n))
end

def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end
def vect_product(p=2) ; all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)} ; end

def vector_classes(k,m=ID,vs) ; vs.map do |v|
	it,*iterates = (1...vs.count).map{|i|((m**i)*v).map{|i|i%k} }
	iterates.take_while{|v|v!=it}.unshift(it) ; end
end

def orthogonal(p=2) ; vect_product(p).select{|m|m*m.transpose==ID} ; end
def special_linear(p=2) ; vect_product(p).select{|m|(m.det)%p==1} ; end

def tranny_classes(k,ts) ; ts.map do |t|
	(1...ts.count).map{|i|(t**i).map{|i|i%k} }.take_while{|t|t!=ID}.unshift(ID) ; end
end

def draw
	clear ; translate(@w,@h)
	tranny = @transformation.shift ; @transformation<<tranny
	text("#{tranny.to_a[0]}\n#{tranny.to_a[1]}",width-1000,100) # 500

	# take classes of vectors and color'em
	vector_classes(@order,tranny,all_vs(@order)).map do |srcs|
		colors = (0..2).map{rand(255)} ; stroke(*colors,50)
		trgs = srcs.map{|v| (tranny*v).map{|i|(i % @order)}}
		edges = srcs.zip(trgs).map{|a,b|(a.to_a+b.to_a).map{|i|i*70}}
		edges.each{|edge|line(*edge)}
	end
end
