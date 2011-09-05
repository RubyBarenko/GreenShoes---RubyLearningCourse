require 'green_shoes'
WIDTH, HEIGHT = 800,600
Shoes.app width:WIDTH, height:HEIGHT do
  button 'Save' do
    save
  end
  motion do
    b, x, y = mouse
    @ox||=x; @oy||=y
    line(@ox, @oy, x, y)  if b == 1
    @ox, @oy = x, y
  end

  def save
      surface = Cairo::ImageSurface.new Cairo::FORMAT_ARGB32, WIDTH, HEIGHT
      img = create_tmp_png surface
      p img.methods.sort
      canvas.put img, 0,0
      img.pixbuf.save 'my_picture', 'jpeg', quality:100
  end

end