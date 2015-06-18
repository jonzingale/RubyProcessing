	# An ActiveRecord Visualizer
	require 'csv'
	# FILES_PATH = File.expand_path('./../../..', __FILE__).freeze
	# FILE = "#{FILES_PATH}/arrows.txt".freeze	

	# check on websites
	# forces ? birthday over a partitioning of space?
	# there actually exist has_many_and_belongs_to relations

	# can GRAPH2 be done directly from file?
	GRAPH = [{"website"=>{:trg=>["achiever_queue", "reservation_engine", "clone", "amenity", "auto_disabled", "search_engine", "rate_plan", "event", "clone", "category", "group", "cap_and_bid_group", "event", "sem_clone", "clickable", "visitor", "clone", "category", "click_source", "link_type", "group", "group", "clone", "artist", "clone", "category", "link_type", "clone", "clone", "clones_field", "clone", "venue", "reservation", "event", "link_type", "link_url", "event", "aggregate_event", "group", "borough", "group_cache", "parent", "event", "amenity", "category", "event", "event", "clone", "event", "search_engine", "event", "user", "event", "event", "rating_category", "event", "event_field", "credentialed", "group", "group_relation_type", "group_type", "group", "clone", "child", "parent", "local", "remote", "owner", "attachable", "indexable", "reservation_engine", "lodging_proxy", "property", "state", "city", "group_cache", "market", "reservation_engine", "event", "group", "event", "search_engine", "notable", "assigned_to", "authored_by", "lodging", "rate_plan", "lodging", "rated", "clone", "event", "category", "click_source", "link_type", "group", "reservation", "visitor", "website", "event", "redirect_depth", "most_recent_note", "achiever_queue", "event", "visitor", "referral", "city", "user", "role", "event", "lodging", "clone", "site", "clone", "clone", "event", "category", "click_source", "link_type", "group", "reservation", "event", "user", "clone", "user", "event", "user", "group", "visitor", "submission_click", "market", "clone", "website", "website"], :out_d=>133, :in_d=>132}}, {"achiever_queue"=>{:trg=>[], :out_d=>0, :in_d=>2}}, {"reservation_engine"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>3}}, {"clone"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>16}}, {"amenity"=>{:trg=>[], :out_d=>0, :in_d=>2}}, {"auto_disabled"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"search_engine"=>{:trg=>[], :out_d=>0, :in_d=>3}}, {"rate_plan"=>{:trg=>["website"], :out_d=>1, :in_d=>2}}, {"event"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>21}}, {"category"=>{:trg=>[], :out_d=>0, :in_d=>6}}, {"group"=>{:trg=>["website"], :out_d=>1, :in_d=>10}}, {"cap_and_bid_group"=>{:trg=>["website"], :out_d=>1, :in_d=>1}}, {"sem_clone"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"clickable"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"visitor"=>{:trg=>[], :out_d=>0, :in_d=>4}}, {"click_source"=>{:trg=>[], :out_d=>0, :in_d=>3}}, {"link_type"=>{:trg=>[], :out_d=>0, :in_d=>5}}, {"artist"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"clones_field"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"venue"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>1}}, {"reservation"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>3}}, {"link_url"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"aggregate_event"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"borough"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"group_cache"=>{:trg=>[], :out_d=>0, :in_d=>2}}, {"parent"=>{:trg=>[], :out_d=>0, :in_d=>2}}, {"user"=>{:trg=>[], :out_d=>0, :in_d=>5}}, {"rating_category"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"event_field"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"credentialed"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"group_relation_type"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"group_type"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"child"=>{:trg=>["website"], :out_d=>1, :in_d=>1}}, {"local"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"remote"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"owner"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"attachable"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"indexable"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"lodging_proxy"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"property"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"state"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"city"=>{:trg=>[], :out_d=>0, :in_d=>2}}, {"market"=>{:trg=>["website"], :out_d=>1, :in_d=>2}}, {"notable"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"assigned_to"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"authored_by"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"lodging"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>3}}, {"rated"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"redirect_depth"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"most_recent_note"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"referral"=>{:trg=>["website"], :out_d=>1, :in_d=>1}}, {"role"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"site"=>{:trg=>[], :out_d=>0, :in_d=>1}}, {"submission_click"=>{:trg=>["website", "website", "website", "website", "website", "website", "website"], :out_d=>7, :in_d=>1}}, {"sites_clone"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"google_partner_remote_listing"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"ruby_event"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"trip_advisor_setting"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"wyndham_remote_listing"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"roomer_remote_listing"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"open_table_identity_map"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"achiever_stat"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"events_amenity"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"amenities_clone"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"cap_and_bid_group_event"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"auto_disabled_log"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"trip_advisor_auto_disabled_log"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"booking_submission"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"events_category"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"click"=>{:trg=>["website", "website", "website", "website", "website", "website", "website", "website", "website"], :out_d=>9, :in_d=>0}}, {"group_cach"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"clones_category"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"clones_link_type"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"events_clone"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"users_clone"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"clones_value"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"clones_venue"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"clones_artist"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"region"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"google_ad_report"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"events_value"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"event_link"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"active_events_clone"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"events_minimum_stay"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"events_interface"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"rate"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"lodgings_lookup"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"remote_listing"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"users_event"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"note"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"log"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"events_rating_category"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"google_ad_report_row"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"bids_event"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"monthly_search_budget"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"monthly_trip_advisor_budget"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"monthly_google_budget"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"trip_advisor_remote_listing"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"restaurant"=>{:trg=>["website", "website", "website"], :out_d=>3, :in_d=>0}}, {"users_group"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"parent_groups_group"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"children_groups_group"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"package"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"indexer_failure"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"index_schedule"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"availability"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"span"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"trip_advisor_compound_key"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"conversion_value"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"identity_mapping"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"visitors_submission_click"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"roles_user"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"event, remote_listing"=>{:trg=>["website"], :out_d=>1, :in_d=>0}}, {"settings_ever_sent"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}, {"clients_ever_sent_to"=>{:trg=>["website", "website"], :out_d=>2, :in_d=>0}}].freeze
	ARROWS = eval(File.read("/Users/Jon/Desktop/arrows.txt")).freeze
	VERTICES = GRAPH.map(&:keys).flatten

	def setup
		text_font create_font("SanSerif",9);
		# size(1920,1080) #JackRabbit
		square = [1080] * 2 ; screen = [1700,1000] ; size(*screen)

		@w,@h = screen.map{|d| d/2}
		@i, @t = [0] * 2 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 3.5 ; colorMode(HSB,360,100,100)
		no_fill() ; no_stroke ; size(*screen) ; @xy = [0,0]
	end

	# in_coming is blue, out_going red
	def color_v(data) ; (1..2).map{|i|[Math.log(data[i]+1) * 25] * 2} end

	def draw 
	 clear 
	 @i += 1 
	 plot_verts(GRAPH)
	 text(ARROWS.to_s,@w,@h)
	end

	def get_coords(coords_colors)
		if @i == 1
			cd = VERTICES.map{|r| [(20 + rand(@w)) * 1.5, 
														 (20 + rand(@h)) * 1.5] }
			cl = VERTICES.map{|c| rand(30) }
			@cc = cd.zip(cl)
		else
			coords, colors = coords_colors.transpose
			cd = coords.map{|x,y| [(x+(-1)**rand(2)/10.0) % (@w*1.9) ,
														 (y+(-1)**rand(2)/10.0) % (@h*1.9)] }
			@cc = cd.zip(colors)
		end
	end

	# vert name, in_deg, out_deg
	def plot_verts(graph)
		vert_data = graph.map do |arr|
			src = [arr].map(&:keys).flatten[0]
			[src] + [:in_d, :out_d].map{|s|arr[src][s]}
		end

		# data = [name, in, out]
		vert_data.each_with_index do |data,index|
			@xy = get_coords(@cc).transpose[0][index]

			fill(200+@cc.transpose[1][index],50,93)
			text(data[0],*@xy) ; blue, red = color_v(data)
			fill(180,100,100,90) ; ellipse(*@xy,*blue) # blue
			fill(10,100,100,70)	; ellipse(*@xy,*red) # red
		end
	end

