require 'green_shoes'
Shoes.app do
   @time = title "0:00"
   every 1 do
     #@time.replace(Time.now.strftime("%I:%M %p")) # 12-hour time
     @time.replace(Time.now.strftime("%H:%M")) # 24-hour time
   end
 end
