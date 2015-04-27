#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'

#todo: 	# partition vectors, given a tranny.

require 'byebug'
require 'matrix'
	WIDTH = 100 ; HEIGHT = 100
	BASES = (0...4).map{|i|2**i}.freeze # 1,2,4,8
  ID = Matrix.columns([[1,0],[0,1]])
	ALL_POINTS = (0...2**4).inject([],:<<).freeze
	@w, @h, @i = [WIDTH,HEIGHT].map{|i|i/2.0} << 0
	@rand_c = (0..2).map{rand(255)}
	PI = 3.1415926


def n_ary(n=2,x=0,ary=[])
	x==0 ? [0,0].drop(ary.count)+ary : n_ary(n,x/n,ary.unshift(x%n))
end

#######Vectors
def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end

def vector_classes(k,m=ID,vs)
	vs.map do |v|
		it,*iterates = (1...vs.count).map{|i|((m**i)*v).map{|i|i%k} }
		iterates.take_while{|v|v!=it}.unshift(it)
	end
end

#######Transformations: partition trannies into classes.
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


def process
	while @i > -1 ; @i+=0.01
		it = Matrix[[1, 3], [0, 1]]
		v_classes = vector_classes(5,it,all_vs)
byebug
  end
end

def prints(ary=[]) ;ary.map{|a|puts "#{a.sort_by{|i|i.count}.reverse }"}.compact end


process

byebug ; 4