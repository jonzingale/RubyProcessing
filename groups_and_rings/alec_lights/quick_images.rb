def setup
  text_font create_font("SanSerif",20)
  size(displayWidth/2, displayHeight/3.3)
  colorMode HSB, 360, 100, 100
  background 0
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
  
  no_fill ; stroke(120) ; stroke_weight(5)
  rect(xs, ys, @width/1.5, ys)

  no_stroke
  it = [1,0,1,1,0,0,0,0]
  jt = [0,1,0,1,0,0,0,0]

  it.each_with_index do |l, i|
    fill(180*l, 80, 100)
    ellipse(xs+ xs/4.5 + 60*i, ys + xs/3, 35, 35)
  end

  fill(180, 80, 100) # ON
  ellipse(@width/5 + 85, @height/5, 35, 35)
  fill(0, 80, 100) # OFF
  ellipse(@width/5 + 230, @height/5, 35, 35)

  fill(90, 20, 100)
  text("Where        is ON and        is OFF.", @width/5, @height/5 + 5 )
end