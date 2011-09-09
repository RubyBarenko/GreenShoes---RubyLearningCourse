require 'green_shoes'
Shoes.app title: "A Glossy Button", width: 400,  height: 300 do
 nostroke
 fill green..orange
 bg = oval 100, 100, 100, 50, fill: white
 para strong('click here!'), left: 110, top: 115, stroke: red
 upper = arc 100, 100, 100, 50, Math::PI, 0, angle: 45
 under = arc 100, 100, 100, 50, 0, Math::PI, angle: 45
 bg.hover do
   upper.move upper.left, upper.top - 10
   under.move under.left, under.top + 10
 end
 bg.leave do
   upper.move upper.left, upper.top + 10
   under.move under.left, under.top - 10
 end
 bg.click{alert 'Yes, clicked!'}
end