def setup
  text_font create_font("Courier",30)
  size(displayWidth/2, displayHeight/3.3)
  colorMode HSB, 360, 100, 100
  background(0,0,100)
end
def save_it
  if key_pressed? && key_code = 38
    file = File.expand_path(File.dirname(__FILE__))
    filename = "#{file}/quick_image.png"

    puts "Got it"
    save(filename)
  end
end
def draw
  save_it
  xs, ys, ss = @width/5, @height/3, @width/1.5
  

  # rect(xs, ys, @width/1.5, ys)

  fill(0) ; stroke(0,0,100) 
  text("  (0 0 0 1 0 0 0 0)", 150, 100)
  text("+ (e e e a e e a e)", 150, 130)
  text("___________________", 150, 145)
  text("  (0 0 0 0 0 0 1 0)", 150, 180)
end