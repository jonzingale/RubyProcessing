#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'
require 'matrix'
require 'byebug'
WIDTH = 100 ; HEIGHT = 100
simplices = (0..6).map{|s| eval("SIMPLEX_#{s} = (0..#{s}).to_a")}.freeze

def abs(i) ; ((i**2)**0.5).to_i ; end
def is_compact?(simplex) ; del(del(simplex)).flatten.inject(0,:+) == 0 ; end

def del(simplex)
	simplex[0].is_a?(Array) ? simplex.inject([]){|xs,s| xs + del(s) } :
	simplex.map.with_index{|s,i| simplex.reject{|x| x == s}.map{|j| j*(-1)**i } }
end

# a weird function
# [:push,:pop].inject([]){|ds,meth| ds << (sig|sig).send(meth)  }

def cross_product(vs,ws)# cross_product needs ruby 2.1 or greater.
	indices = [0,1,2].map{ |i| [0,1,2].delete_if{|j| i==j }}
	if [vs,ws].all?{|vect| vect.count == 3 }
		a, b = [vs,ws].map{|vect| indices.map{|i,j| Vector[vect[i],vect[j]] }}
		Vector.elements(a.zip(b).map.with_index{|m,i| Matrix.rows(m).det * (-1)**i})
	end
end

def fact(n,r) ; ((n-r+1)..n).to_a.inject(1,:*) ; end

def birthdays(t)
	(1..t).map do |n|
		person = (1..n).min_by{ |k| ((0.5-(fact(n,k)/(n**k.to_f)))**2)**0.5 }
		[n, person, ((n**0.5)*6/5).to_i, n/person.to_f]
	end
end	

def prty(it)
	unless it.empty?
		[it.take(3)].map{|t| puts "#{t}"}
		prty(it.drop(3)) 
	end
end

def oriented?(face,pt)
	a, b, c, p = (face << pt).map{|a| Vector.elements(a)}
	cross_product(b-a,c-a).inner_product(p-a) < 0
end

# if two edges have a common vertex
# name and cut, otherwise don't.
def split_triangle(e1,e2)
	if (sig = e1|e2).count == 3
		hs = Hash.new ; keys = %w(a b c d e)
		keys.zip(sig+['p','q']).each{|i,e| hs[i]=e}
		%w(adc dec dbe).map{|a| a.split('').map{|i| hs[i]}}
	end
end

def process
	birthdays(9)
	# it = split_triangle([0,1],[1,3])
	# cross = cross_product(Vector[1,0,0],Vector[0,1,0])

	# face = [[1,4,6],[7,2,5],[6,1,5]] ; point = [12,5,2]
	# oriented?(face, point)
byebug
end

process

byebug ; 4