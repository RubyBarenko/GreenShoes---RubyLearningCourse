require 'green_shoes'
Shoes.app do
   motion do
     b, x, y = mouse
     @ox||=x; @oy||=y
     line(@ox, @oy, x, y)  if b == 1
     @ox, @oy = x, y
   end
 end