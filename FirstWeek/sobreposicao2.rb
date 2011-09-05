require 'green_shoes'

class Group < Array
  def move(x,y)
    @x0||=x; @y0||=x
    dx,dy = x-@x0, y-@y0
    each {|e| e.move e.left+dx,e.top+dy}
    @x0, @y0 = x, y
  end
end

Shoes::App.class_eval {def group(&block); block.call Group.new; end}


Shoes.app width:400,height:400 do
  nostroke
  para "Click and move!", align:'center'
  colors = []
  colors << oval(radius:100, left:100, top:50, fill:red)
  colors << oval(radius:100, left:50, top:150, fill:green)
  colors << oval(radius:100, left:150, top:150, fill:blue)

  gp = group do |g|
    g << colors[0]
    g << colors[2]
  end

  motion do
    b,x,y = mouse 
    gp.move x,y if b==1
  end
end
