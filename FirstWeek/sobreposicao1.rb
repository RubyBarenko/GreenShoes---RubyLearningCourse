require 'green_shoes'

class Group < Array
  def <<(element)
    super
    element.define_singleton_method(:onclick) do |*value|
      return @onclick||=false if value.empty?
      @onclick = value[0]
    end
  end
  
  def move(x,y) 
    @mouse_P0 ||= Complex(x,y)
    @mouse_P = Complex(x,y)
    @mouse_dP = Complex(x,y) - @mouse_P0

    each do |e|
      center = Complex(e.left + e.width/2, e.top + e.height/2)
      if e.width/2 >= (@mouse_P - center).magnitude then
        delta = e.onclick ? @mouse_dP : Complex(x,y) - @mouse_P
        e.move e.left+delta.real,e.top+delta.imag
        e.onclick(true)
      else
        e.onclick(false)
      end
    end
    @mouse_P0 = @mouse_P
  end
end


Shoes.app width:400,height:400 do
  nostroke
  para "Click and move!", align:'center'
  colors = Group.new
  colors << oval(radius:100, left:100, top:50, fill:red)
  colors << oval(radius:100, left:50, top:150, fill:green)
  colors << oval(radius:100, left:150, top:150, fill:blue)
  
  
  
  motion do |x,y| 
    b,x,y = mouse 
    if b==1 then
      colors.move x,y 
    end
  end
end
