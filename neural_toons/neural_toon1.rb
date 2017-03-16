# !/usr/bin/env ruby
# require 'open-uri'
require 'mechanize'

IMAGES_PATH = File.expand_path('.', File.dirname(__FILE__)).freeze
# StarPath = "#{IMAGES_PATH}/kitzen.png".freeze
StarPath = "#{IMAGES_PATH}/transparent.png".freeze

NAME_REGEX = /\/(\w+_?)+(.png)?$/.freeze

def setup
  size(displayWidth/2, displayHeight/1)
  background(0)
  @cat_image = loadImage(StarPath)
  image(@cat_image, 0, 0, *rescalar)
  load_pixels
end

def transparentize
  `convert test.png -transparent white transparent.png`
# pxls[i] : if the diff or the 3 numbers is small about 255 then transparent.


# save("#{IMAGES_PATH}/images/calvinhobbes_#{@stub}.png")
end

def draw
  # background(rand 6*10**8)
  image(@cat_image, 0, 0, *rescalar)
end

# def white_to_blank
#   @cat_image.pxl


#   pixels[w+h*@width] = color

# end

# def puts_pixel thread
#   window = width, height

#   until window.pxl == [0,0]
#     window.update_vect
#     w, h = window.pxl
#     color = color(360/(thread+1),70,100)
#     pixels[w+h*@width] = color
#   end
# end


def rescalar
  w_cat = @cat_image.width
  h_cat = @cat_image.height
  s = width/@cat_image.width.to_f
  [w_cat * s, h_cat * s]
end
  def mouseMoved
    coords = [(mouseX or 10),(mouseY or 10)]
    fill(20); rect(50,50,200,100)
    fill(123,90,90,255)
    # text("#{coords}",100,100)
    text("#{rgb_converter(*coords)}",100,100)
  end

  def rgb_converter(m=0,n=0)
    k = get(m,n)
    r = 256 + k/(256**2)
    g = k/256 % 256
    b = k % 256
    [r,g,b]
  end

def name_stub stub
  stub.gsub!('-','_')
  @stub = NAME_REGEX.match(stub)[1]
end