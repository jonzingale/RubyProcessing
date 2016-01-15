#!/usr/bin/env ruby 
# require 'ruby-2.0.0-p247'

# Test space for an ActiveRecord Visualizer
require 'byebug'

# FILE = File.read("/Users/Jon/Desktop/arrows.txt").freeze
# ARROWS = eval(FILE).freeze
ARROWS = eval(File.read("/Users/Jon/Desktop/arrows.txt")).freeze

MODELS = %w(achiever_queue achiever_stat aggregate_event amenities_clone amenity api_url auto_disabled_log availability bids_event blueprints booking_submission cached_page cap_and_bid_group_event cap_and_bid_group category click_source click clone clones_artist clones_category clones_field_hash clones_field clones_link_type clones_value clones_venue conversion_value emailer encoding_fixer event_field event_link event_note event events_amenity events_category events_clone events_interface events_log events_minimum_stay events_rating_category events_value external_credential group_cache group_relation_type group_type group groups_clone groups_group identity_mapping image index_schedule indexer_failure link_type link_url location lodging_proxy lodgings_lookup los_rate market monthly_search_budget note package pollable_resque_result rate_plan_span rate_plan rate_with_tax rate rating_category redirect_depth redis_key referral remote_listing reservation_engine reservation restaurant role roles_user room_rate_avail_day roomer_reservation ruby_event search_engine site sites_clone submission_click trip_advisor_client trip_advisor_setting url_params user_notifier user_session user users_clone users_event users_group visitor visitors_submission_click website).freeze
VERTS = ARROWS.map{|kva|kva.first}.flatten.uniq.freeze
VERTS_NOT_MODELS = VERTS - MODELS # they are just referenced!!

def _V(data) ; end



def process

	each_totals = ARROWS.map{|g|g[:counts].values}.transpose.map{|c|c.inject(0,:+)}

	# ARROWS.map{|g|g[:counts].values}.transpose.map{|c|c.inject(0,:+)/124.0}
	avg_degrees = [1.6290322580645162, 1.0564516129032258, 0.03225806451612903]

	avg_degrees.map{|i|[Math.log(i+1) * 10] * 2}
	avg_size = [9.666158157616708, 7.209819795533894, 0.3174869831458027]
	avg_radius = [4.833079078808354, 3.604909897766947, 0.15874349157290135]

	area = 3.14 * 4.83**2 * 124
	seg = area ** 0.5

	guess = (seg-seg**2)/(2*Math.log(0.5))
	# 6441.6333575692215 pixels per side?!

# well, maybe !! 
	byebug
end

private


def prin(result) ; result.map{|r| puts "#{r}"}.compact ; end

process
; byebug ; 4





# ARROWS[:belongs_to][0].class -> Hash
# {"achiever_stat"=>"achiever_queue"}

# [:belongs_to, 6199]
# [:has_one, 535]
# [:has_many, 5942]
# [:has_many_through, 70]
# [:has_one_through, 10]
# [:has_and_belongs_to_many, 123]

# VERTS.count -> 130 ; [[2,1],[5,1],[13,1]]
# ALL_ARROWS.count -> 12879 ; [[3,5],[53,1]]
# ALL_ARROWS.uniq.count -> 6288 ; [[2,4],[3,1],[131,1]]

# yeah, lots of redundant information.
# namely, every belongs_to has a corresponding
# has_many or has_one. This suggests an obvious
# optimization. Perhaps, only the 'has' series.






