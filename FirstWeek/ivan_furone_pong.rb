require 'green_shoes'
 
Shoes.app width: 400, height: 400, resizable: false do
  xspeed, yspeed = 7, 8
 
  nostroke
  @ball = oval 0, 0, 20, 20, fill: green
  @paddle1 = rect 0, 0, 75, 4, curve: 2
  @paddle2 = rect 0, 396, 75, 4, curve: 2
 
  @anim = animate 20 do
    if @ball.top + 20 < 0 or @ball.top > 400 then para 'Game Over'; @anim.stop; end
    xdir, ydir = @ball.left + xspeed.to_i, @ball.top + yspeed.to_i
 
    xspeed = -xspeed  if xdir + 20 > 400 or xdir < 0
 
    if ydir + 20 > 400 and xdir + 20 > @paddle2.left and xdir < @paddle2.left + 75
      yspeed = -yspeed * 1.2
      xspeed = (xdir - @paddle2.left - (75 / 2)) * 0.25
    end
 
    if ydir < 0 and xdir + 20 > @paddle1.left and xdir < @paddle1.left + 75
      yspeed = -yspeed * 1.2
      xspeed = (xdir - @paddle1.left - (75 / 2)) * 0.25
    end
 
    @ball.move xdir, ydir
    @paddle2.left = mouse[1] - (75 / 2)
    @paddle1.left += 10  if @paddle1.left + 75 < @ball.left
    @paddle1.left -= 10  if @ball.left + 20 < @paddle1.left
  end
end