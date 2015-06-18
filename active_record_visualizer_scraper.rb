#!/usr/bin/env ruby 
# require 'ruby-2.0.0-p247'

# Scraper for ActiveRecord Visualizer
require 'activesupport'
require 'byebug'
require 'csv'

MODELS = %w(achiever_queue achiever_stat aggregate_event amenities_clone amenity api_url auto_disabled_log availability bids_event blueprints booking_submission cached_page cap_and_bid_group_event cap_and_bid_group category click_source click clone clones_artist clones_category clones_field_hash clones_field clones_link_type clones_value clones_venue conversion_value emailer encoding_fixer event_field event_link event_note event events_amenity events_category events_clone events_interface events_log events_minimum_stay events_rating_category events_value external_credential group_cache group_relation_type group_type group groups_clone groups_group identity_mapping image index_schedule indexer_failure link_type link_url location lodging_proxy lodgings_lookup los_rate market monthly_search_budget note package pollable_resque_result rate_plan_span rate_plan rate_with_tax rate rating_category redirect_depth redis_key referral remote_listing reservation_engine reservation restaurant role roles_user room_rate_avail_day roomer_reservation ruby_event search_engine site sites_clone submission_click trip_advisor_client trip_advisor_setting url_params user_notifier user_session user users_clone users_event users_group visitor visitors_submission_click website)
CLASS_REGEX = /class (\w+) < ActiveRecord::Base/.freeze

FILES_PATH = File.expand_path('./../../..', __FILE__).freeze
MODELS_PATH = File.expand_path('./../../../../src/hotel_scraper/app/models', __FILE__).freeze
FILE =  "#{FILES_PATH}/arrows.txt".freeze

ASSOCS_REGEX = /^ +belongs_to|^ +has_one|^ +has_many|^ +has_and_belongs_to_many/.freeze

ASSOC_HASH = {belongs_to: [], has_one: [], has_many: [], has_many_through: [],
							has_one_through: [], has_and_belongs_to_many: []}

@bash = {belongs_to: [], has_one: [], has_many: [], has_many_through: [],
				 has_one_through: [], has_and_belongs_to_many: []}

ASSOCS = ['belongs_to', 'has_one', 'has_many', 'has_many :through',
					'has_one :through','has_and_belongs_to_many'].freeze

ASSOC_SEL = ASSOC_HASH.keys.zip(ASSOCS).freeze
THROUGH_SEL = [[:has_many, :has_many_through],
							 [:has_one, :has_one_through]].freeze

def get_arrows ; MODELS.each{|model| get_active_record("#{model}.rb")} ; end
def hash_to_txt ; File.open(FILE, 'w') { |f| f << @bash } ; end

def get_active_record(file_name)# gets all association strings and sorts em'
	file = File.open(MODELS_PATH+"/#{file_name}")
	hash, table = [ASSOC_HASH, '']

	file.each do |line| # strip the files down, grab class name and associations.
		(t_line = CLASS_REGEX.match(line)).nil? ? nil : (table = t_line[1].tableize.singularize)
		match_cond = (mt = ASSOCS_REGEX.match(line)).nil?
		match_cond ? nil : hash[ASSOC_SEL.detect{|k,v| mt[0].strip == v}[0]] << line
	end

	THROUGH_SEL.each do |has,thr| # sorts the throughs from the non-through strings
		hash[thr], hash[has] = hash[has].partition{|hs| /through(:| =>)/.match(hs)}
	end

	hash.keys.each do |k|# removes comment lines, then makes ordered arrows
		hash[k].reject{|com| /^ +#/.match(com)}.each do |assoc|
			arr = assoc.split('through').map do |a|
			  arrow = { /:(\w+)/.match(a)[1].singularize => table}
				@bash[k] << (k == :belongs_to ? arrow.invert : arrow)
			end
		end
	end
end

def process
	get_arrows
	hash_to_txt
end

process