#todo: 	# partition vectors, given a tranny.
require 'matrix'
def setup
  background(20) ; frame_rate 1 ; size(1400,1000) #HOME
	@i, @rand_c =[0,(0..2).map{rand(255)}]
	@w,@h = [width,height].map{|i|i/10.0}
	@mid_v = Vector.elements([@w,@h])
	[:fill,:stroke].each{|f|send(f,*@rand_c)}
end

# there are how many trannies?
def n_ary(n=2,x=0) ; ("%02d" % x.to_s(n)).split('').map(&:to_i) ; end
def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end


#######Transformations
def trannies(n=2) ; tranny_classes(n,unit_trans(n)) ; end
def unit_trans(p=2)
	all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)}.select{|m|(m.det)%p==1}
end

def tranny_classes(k,ts)
	ts.map do |t|
		(1...ts.count).map{|i|(t**i).map{|i|i%k} }.take_while{|t|t!=ID}.unshift(ID)
	end
end
#######


def draw
	clear
	tranny = unit_trans(5)[rand(unit_trans.count)]
	sources = all_vs(5) ; targets = sources.map{|v| (tranny*v).map{|i|i%5}}
	edges = sources.zip(targets).map{|a,b|(a.to_a+b.to_a).map{|i|i*200}}

	edges.each{|edge|line(*edge)}
end