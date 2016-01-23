# !/usr/bin/env ruby
require 'open-uri'
require 'mechanize'

IMAGES_PATH = File.expand_path('.', File.dirname(__FILE__)).freeze
HobbesPath = "#{IMAGES_PATH}/hobbes.png".freeze
CalvinPath = "#{IMAGES_PATH}/calvin.png".freeze
StarPath = "#{IMAGES_PATH}/nasa_img.jpg".freeze

HubblePath = 'http://hubblesite.org/gallery/wallpaper/'.freeze
HubbleImage_Sel = './/div[@class="wallpaper"]//img'.freeze

NasaPath = 'http://apod.nasa.gov/apod/'.freeze
NasaImage_Sel = './/img/parent::a'.freeze
NAME_REGEX = /\/(\w+_?)+(.jpg)?$/.freeze

def setup
	size(displayWidth, displayHeight)

	rand(3) == 0 ? get_nasa_pic : get_hubble_pic

	@star_image = loadImage(StarPath)
	image(@star_image, 0, 0, *rescalar)

	calvin_or_hobbes = [HobbesPath, CalvinPath][rand 2]
	@hobbes_image = loadImage(calvin_or_hobbes)
	image(@hobbes_image, 0, 0, 1920, 1080)

	epoch = DateTime.now.strftime('%s')
	save("#{IMAGES_PATH}/images/calvinhobbes_#{@stub}.png")
end

def rescalar
	width = @star_image.width
	height = @star_image.height
	s = 1920/@star_image.width.to_f
	[width * s, height * s]
end

def get_hubble_pic
	agent = Mechanize.new
	page = agent.get(HubblePath)
	images = page.search(HubbleImage_Sel)
	rand_image = images[rand(images.count)]['src']
	stub, junk = rand_image.split('wallpaper')
	hubble_pic = stub + '1920x1200_wallpaper.jpg'

	open(StarPath, 'wb') {|f| f << open(hubble_pic).read }
	name_stub stub
end

def get_nasa_pic
	agent = Mechanize.new
	page = agent.get(NasaPath+'astropix.html')
	stub = page.at(NasaImage_Sel)['href']

	open(StarPath, 'wb') {|f| f << open(NasaPath+stub).read }
	name_stub stub
end

def name_stub stub
	stub.gsub!('-','_')
	@stub = NAME_REGEX.match(stub)[1]
end