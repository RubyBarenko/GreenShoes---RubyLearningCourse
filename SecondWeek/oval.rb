require 'green_shoes'
 
Shoes.app title: "A Glossy Button", width: 400,  height: 300 do
 
  #Credits to ashbb!
 
 
  @glossy = oval  top: 100, height: 50, left: 15, width: 100, fill: green
  @o = oval  top: 100, height: 50,  left: 15, width: 100, fill: green
  @label = para 'OK', top: 115, left: 60, height: 50, stroke: white
   
  #events section
   
  @glossy.hover do 
    @o.move 20, 110
  end
  @glossy.leave do
    @o.move 15, 100
  end
  @o.click do
    alert("hello")
  end
   
end