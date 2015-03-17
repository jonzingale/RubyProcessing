#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'
require 'byebug'
	WIDTH = 100 ; HEIGHT = 100

	def fib(t=0,n=[1,1]) # :: length -> [fibs]
	  f,i,b = n ;
	  n.length > t ? n : fib(t, (n.unshift(f + i)))
	end

	def ffib(n)
	  phi = (1+(Math.sqrt 5))/2
	  fib_f = (phi**n - (-phi)**-n)/(Math.sqrt 5)
	  fib_f.floor
	end

	def fact(n) (1..n).inject(1) {|r,i| r*i } end
	#1.upto(26) {|i| p [i, Math.gamma(i), fact(i-1)] }

	# P0 k k k k P1 k k k k P2
	def poisson(lambda,pts,k) # density, points, grain
		k = k * pts
		Math.exp(-lambda) * (0...k).inject(0) do |s,k|
			s + ((lambda ** k) / fact(k))
		end
	end

	def neighborhood(cell,board)
		c1,c2 = cell.keys[0]
		pairs = [-1,0,1].inject([]){|ns,i| ns+[-1,0,1].map{|j|[i,j]}}

		pairs.map do |cs|
			a,b = cs # maybe Board should be a hash?
			[a+c1%WIDTH,b+c2%HEIGHT]


		end
byebug

	end

	def process


		clear_board = (0...WIDTH).map do |i| 
			(0...HEIGHT).inject([]) do |hs,j|
				hs << {[i,j] => 0 }
			end
		end
	
		cell = {[1,2] => 0}
		neighborhood(cell,clear_board)

		byebug ; 4
	end


process
# 64 bytes from 192.168.1.19: icmp_seq=18 ttl=64 time=0.075 ms
# 64 bytes from 192.168.1.1: icmp_seq=18 ttl=64 time=2.852 ms
# 64 bytes from 192.168.1.21: icmp_seq=18 ttl=64 time=353.994 ms
# 64 bytes from 192.168.1.23: icmp_seq=18 ttl=64 time=354.501 ms
