#!/usr/bin/env ruby 
# require 'ruby-2.0.0-p247'

# Test space for an ActiveRecord Visualizer
require 'byebug'
require 'csv'
CLASS_REGEX = /class (\w+) < ActiveRecord::Base/.freeze
THR_REGEX = /:(\w+),|through(:|:? => ) *:?(\w+)/.freeze

FILES_PATH = File.expand_path('./../../..', __FILE__).freeze
FILE = "#{FILES_PATH}/arrows.csv".freeze

#  {"event"=>{:trg=>["aggregate_event" ... "parent"], :out_d=>5, :in_d =>42}}
def with_deg(graph)
	arrows = {directed: [], undirected: []}

	graph.map do |arr|
		src, trg = [:keys, :values].map{|k|arr.send(k).first}
		out_deg = trg.count
		in_deg =  graph.map{|arr|arr.values}.flatten.select{|trg|src == trg}.count
		arrows[:directed] << {src => {trg: trg,out_d: out_deg,in_d: in_deg} }
	end ; arrows[:directed].flatten
end

def process
	# file = File.read(FILE)
	# it = file.split("\n").map{|st|st.split(',')}
	data = with_deg(graph)
	byebug
end

private

def graph
	ary = CSV.read(FILE).drop(1)
	arrows = {directed: [], undirected: []}
	vertices = ary.flatten.uniq
	[:directed,:undirected].each do |sym|
		arrows[sym] = vertices.map do |v|
			{v => ary.select{|arr| arr[0] == v}.map(&:last)}
		end
	end ; arrows[:directed]
end

def prin(result) ; result.map{|r| puts "#{r}"}.compact ; end
# def init_csv ; CSV.open(FILE, 'w'){|csv| csv << ['source','target'] } ; end
# def _V(graph) ; graph.map(&:keys).flatten ; end

process
; byebug ; 4
