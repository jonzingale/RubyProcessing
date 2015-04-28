# colors vector paths about a two dimensional vector space,
# for randomly given det 1 matrices over a finite field @prime.
# todo: On a donut or at least center the thing.
#       @prime > 12
#       what relation between @w factor and edges factor?

# 			text("#{tranny,num_classes}",@w,100)
#       spread colors, how many classes?

require 'matrix'
def setup
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.3 ; size(1400,1000) #HOME
  @prime = 12 ; @units = unit_trans(@prime).shuffle
	@w,@h = [width,height].map{|i|i/10.0}
end

def n_ary(n=2,x=0,ary=[])
	x==0 ? [0,0].drop(ary.count)+ary : n_ary(n,x/n,ary.unshift(x%n))
end

def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end
def trannies(n=2) ; tranny_classes(n,unit_trans(n)) ; end

def vector_classes(k,m=ID,vs) ; vs.map do |v|
	it,*iterates = (1...vs.count).map{|i|((m**i)*v).map{|i|i%k} }
	iterates.take_while{|v|v!=it}.unshift(it) ; end
end

def unit_trans(p=2)
	all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)}.select{|m|(m.det)%p==1}
end

def tranny_classes(k,ts) ; ts.map do |t|
	(1...ts.count).map{|i|(t**i).map{|i|i%k} }.take_while{|t|t!=ID}.unshift(ID) ; end
end

def draw
	clear ; translate(@w,@h)
	tranny = @units.shift ; @units<<tranny
	text("#{tranny.to_a[0]}\n#{tranny.to_a[1]}",width-500,100)
	# take classes of vectors and color'em
	vector_classes(@prime,tranny,all_vs(@prime)).map do |v_class|
		colors = (0..2).map{rand(255)} ; stroke(*colors)
		srcs = v_class ; trgs = srcs.map{|v| (tranny*v).map{|i|i% @prime}}
		edges = srcs.zip(trgs).map{|a,b|(a.to_a+b.to_a).map{|i|i*75}}
		edges.each{|edge|line(*edge)}
	end
end
