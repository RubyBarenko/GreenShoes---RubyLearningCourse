begin
  require 'green_shoes'
rescue LoadError
  class Shoes::Types::Shape
    [:ileft, :itop].each do |m|
      define_method(m){style[m]}
      define_method("#{m}="){|arg| style m => arg}
    end
  end
end

Shoes.app width:400,height:400 do
  nostroke
  para "Click and move!", align:'center'
  colors = []
  colors << oval(radius:100, left:100, top:50, fill:red, ileft:100, itop:50)
  colors << oval(radius:100, left:50, top:150, fill:green, ileft:50, itop:150)
  colors << oval(radius:100, left:150, top:150, fill:blue, ileft:150, itop:150)

  group = [colors[0], colors[2]]

  motion do
    b,x,y = mouse
    if b == 1
      dx, dy = @x - x, @y - y
      group.each{|c| c.move c.ileft - dx, c.itop - dy}
    else
      @x, @y = x, y
      group.each{|c| c.ileft, c.itop = c.left, c.top}
    end
  end
end