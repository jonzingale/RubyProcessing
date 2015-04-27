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

	# there are how many trannies?
	def n_ary(n=2,x=0) ; ("%02d" % x.to_s(n)).split('').map(&:to_i) ; end
	def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end

	def unit_trans(p=2)
		all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)}.select{|m|(m.det)%p==1}
	end

	# partition trannies into classes.
	def tranny_classes(t_ary=[],ary=[])
		t_len = t_ary.count ; t,*ts = t_ary
		if ts.empty? ; ary <<[t] ; else
			iterates = (0...t_len).map{|i|(t**i).map{|i| i % 5} }.uniq
			a,b = t_ary.partition{|m|iterates.include?(m)}
			tranny_classes(b,ary<<a)
		end
	end


def process
	while @i > -1 ; @i+=0.01
		it = tranny_classes(unit_trans(5))

		# prints classes
		it.sort_by{|t|t.count}.reverse.map{|i|puts "#{i}"}.count
byebug



  end
end


process

byebug ; 4