#!/usr/bin/env ruby 
# require 'ruby-2.0.0-p247'

# Scraper for ActiveRecord Visualizer
require 'activesupport'
require 'byebug'
require 'csv'

MODELS = %w(achiever_queue achiever_stat aggregate_event amenities_clone amenity api_url auto_disabled_log availability bids_event blueprints booking_submission cached_page cap_and_bid_group_event cap_and_bid_group category click_source click clone clones_artist clones_category clones_field_hash clones_field clones_link_type clones_value clones_venue conversion_value emailer encoding_fixer event_field event_link event_note event events_amenity events_category events_clone events_interface events_log events_minimum_stay events_rating_category events_value external_credential group_cache group_relation_type group_type group groups_clone groups_group identity_mapping image index_schedule indexer_failure link_type link_url location lodging_proxy lodgings_lookup los_rate market monthly_search_budget note package pollable_resque_result rate_plan_span rate_plan rate_with_tax rate rating_category redirect_depth redis_key referral remote_listing reservation_engine reservation restaurant role roles_user room_rate_avail_day roomer_reservation ruby_event search_engine site sites_clone submission_click trip_advisor_client trip_advisor_setting url_params user_notifier user_session user users_clone users_event users_group visitor visitors_submission_click website).freeze
FILES_PATH = File.expand_path('./../../..', __FILE__).freeze
MODELS_PATH = File.expand_path('./../../../../src/hotel_scraper/app/models', __FILE__).freeze
FILE =  "#{FILES_PATH}/arrows.txt".freeze

ASSOCS_REGEX = /^ +belongs_to|^ +has_one|^ +has_many|^ +has_and_belongs_to_many/.freeze
THROUGH_KEYS_SEL = {has_many: :has_many_through, has_one: :has_one_through}.freeze

ASSOCS = ['belongs_to', 'has_one', 'has_many', 'has_many :through',
					'has_one :through','has_and_belongs_to_many'].freeze

ASSOC_HASH = {belongs_to: [], has_one: [], has_many: [], has_many_through: [],
							has_one_through: [], has_and_belongs_to_many: []}.freeze

ASSOC_SEL = ASSOC_HASH.keys.zip(ASSOCS).freeze

def counter ; @bash.empty? ? nil : (puts "\n\n#{@bash.keys.map{|k|@bash[k].count}}\n\n") ; end
def get_arrows ; MODELS.each{|model| get_active_record("#{model}")} ; end
def to_txt(graph) ; File.open(FILE, 'w') { |f| f << graph } ; end

def get_active_record(file_name)# gets all assoc_str and sorts em'
	file = File.open(MODELS_PATH+"/#{file_name}.rb")

	file.each do |line| # :: File -> {Key => [String, Table]}
		if !(mt = ASSOCS_REGEX.match(line)).nil?
			key_sel = ASSOC_SEL.detect{|k,v| mt[0].strip == v}.first
			through_cond = /through(:| =>)/.match(line)
			new_key = through_cond ? THROUGH_KEYS_SEL[key_sel] : key_sel
			@bash[new_key] << [line,file_name]
		end	 # => [131, 15, 147, 0, 0, 4]
	end 	 # => [131, 10, 112, 35, 5, 4]

	# why so much redundancy? why the need to .uniq?
	@bash.keys.each do |k|# makes ordered arrows
		@bash[k].each do |assoc,tbl|
			assoc.split('through').each do |ass|
				@array << { /:(\w+)/.match(ass)[1].singularize => tbl, assoc: k}
			end
		end
	end
end

def process
	@bash = ASSOC_HASH ; @array = []
  get_arrows ; arrows = @array.uniq
  verts = arrows.uniq.map{|kva|kva.first}.flatten.uniq.freeze

	graph = verts.map do |v|
		out_arrow = arrows.select do |a|
			cond1 = [:belongs_to,:has_and_belongs_to_many].include?(a[:assoc])
			cond2 = a.values.first == v
			cond1 && cond2
		end

		tot_arrow = arrows.select{|a|a[v]}
		both_arrow = tot_arrow.select{|a| [:has_and_belongs_to_many].include?(a[:assoc]) }
		in_arrow = tot_arrow - out_arrow - both_arrow

		{vert: v, 
		 arrows: {in_a: in_arrow, out_a: out_arrow, both_a: both_arrow},
		 counts: {in_c: in_arrow.count, out_c: out_arrow.count, both_a: both_arrow.count}}
	end

  to_txt(graph)
 end

process

