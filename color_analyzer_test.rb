	class Pixels
		attr_accessor :pixels, :sorted
		
		def initialize
			# loadPixels ; updatePixels
			@pixels = 0
			@sorted = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		def partition_colors
			@sorted = sort_colors(pixels)
		end

		def sort_colors(ary,accum=[])
			unless ary.empty?
				ary, ys = ary.partition{|i| i == ary.first}
				sort_colors(ys,accum << ary)
			end ; accum
		end

	end

	require 'byebug'

	def pretty(it)
		it.map{|i| puts "#{i}"}.compact
	end


def p_norm(p,n,i=0)
	n == 0 ? 0 : n % p**i == 0 ? p_norm(p,n,i+=1) : p**(i-1)
end


	pixels = Pixels.new

	ary = (0..200).map{ rand(100) }
	pixels.get_pixels(ary)

	it = pixels.partition_colors

	byebug ; 4
