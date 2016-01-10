# !/usr/bin/env ruby
require 'open-uri'
require 'mechanize'
# IMAGES_PATH = File.expand_path('./../..', File.dirname(__FILE__)).freeze
IMAGES_PATH = File.expand_path('.', File.dirname(__FILE__)).freeze
HobbesPath = "#{IMAGES_PATH}/hobbes.png".freeze
CalvinPath = "#{IMAGES_PATH}/calvin.png".freeze
StarPath = "#{IMAGES_PATH}/nasa_img.jpg".freeze

BaseUrl = 'http://apod.nasa.gov/apod/'.freeze
Image_Sel = './/img/parent::a'.freeze

def setup
	size(displayWidth, displayHeight)

  get_nasa_pic
	@star_image = loadImage(StarPath)
	image(@star_image, 0, 0, *rescalar)

	calvin_or_hobbes = [HobbesPath, CalvinPath][rand 2]
	@hobbes_image = loadImage(calvin_or_hobbes)
	image(@hobbes_image, 0, 0, 1920, 1040)
end

def rescalar
	width = @star_image.width
	height = @star_image.height
	s = 1920/@star_image.width.to_f
	[width * s, height * s]
end

def get_nasa_pic
	agent = Mechanize.new
	page = agent.get(BaseUrl+'astropix.html')
	stub = page.at(Image_Sel)['href']

	open(StarPath, 'wb') {|f| f << open(BaseUrl+stub).read }
end