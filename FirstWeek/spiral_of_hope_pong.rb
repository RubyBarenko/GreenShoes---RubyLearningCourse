=begin
1. Open Shoes Window
    Window's width and height are both 400 pixel.
    Show your app name and revision number on the window's title bar.
 
2. Show two paddles and a ball
    Allocate computer paddle on the top (immobile yet).
    Allocate player's (your) paddle on the bottom.
    Your paddle synchronizes with the mouse movement.
    A ball appears left-top side and moves smoothly to right-bottom side at 20 frames per second.
    [I'm unhappy about the actual 20fps smoothness, but I'm told to not worry]
 
3. Lock-in the ball within the window
    Bounce a ball on the edge of the window.
    Computer's paddle synchronizes with the ball movement.
 
4. Hit the ball
    Have your paddle hit the ball.
    have computer's paddle hit the ball.
    Change ball's speed and bounce angle when the ball is hit.
    [I'm unsure about what changing the bounce angle means.  I do the same basic thing that happens when a wall is struck.]
 
5. Have a match
    When the ball goes over the goal lines, game finishes with victory message.
=end
 
# BUG/TODO/TOWORKAROUND - mouse movement is not tracked/updated fast enough.  It's possible to whip the mouse across and out of the program window, and the paddle will not be trapped in the left wall.  To remedy this, track if the mouse enters/leaves the window.  Track the positioning over time of the paddle.  If the mouse is out, and the position looked like it was going left, then peg the paddle to the left.  Same with the right.
 
# IDEA:  The longer the game plays, the less wide the paddles become, the faster the ball goes.  Can even flash some text up..
 
# IDEA:  Make it resizeable, and act accordingly.  There are things like app.height
 
# User-serviceable variables.
program_version = 0.1
window_height = 400
window_width = 400
ball_speed = 2
# How fast can the computer catch up?
computer_speed = 9
# How random is the computer?
computer_randomness = 2
# 2 is the default for the lesson's animate speed of 20.
# A higher smoothness looks better, but may require a faster computer.
ball_smoothness = 2
ball_radius = 7
paddle_width = 60
paddle_height = 10
playing_field_boundery = 6
playing_field_color = '#FFAA00'..'#009900' # orange..green
background_color = '#333333'..'#000000' # grey..black
ball_fill = '#FF0000' # red
ball_stroke = '#000000' # black
playing_field_stroke = '#FFAA00' # orange
computer_paddle_fill = '#990099' # purple
computer_paddle_stroke = '#000000' # black
computer_paddle_curve = 3
player_paddle_fill = '#FFAA00' # orange
player_paddle_stroke = '#000000' # black
player_paddle_curve = 3
 
# 1. Open Shoes Window
Shoes.app(
            # Window's width and height are both 400 pixel.
            :width => window_width,
            :height => window_height,
            # Show your app name and revision number on the window's title bar.
            :title => "spiralofhope\'s pong, v#{ program_version }",
            #
            :resizable => false,
  ) do
  def end_game( ball_x, ball_y, ball_bounces )
    @ball.hide
    # I'd like to keep the border, but then there are text alignment issues based on playing_field_boundery and the font sizes.
    @border.hide
    @computer_paddle.hide
    @player_paddle.hide
    @animation.stop
    #
    para(
      strong( "Game Over\n" ),
      :align => "center",
      :stroke => orange,
      :size => 18,
    )
    if ball_y > self.height then
      para( "You lost!\n", :align => "center", :stroke => red )
    elsif ball_y < 0 then
      para(
        "You win!\n",
        :align => "center",
        :stroke => green,
      )
    end
    para(
      em( "It took #{ ball_bounces } ball bounce#{ if ball_bounces > 1 then "s" end }." ),
      :align => "center",
      :stroke => orange,
    )
    if ball_bounces > 11 then
      para(
        em( "Wow!" ),
        :align => "center",
        :stroke => green,
      )
    end
  end
 
 
  y_paddle_limit_down  = ( self.height - paddle_height - playing_field_boundery - 5 )
  x_paddle_limit_right = ( self.width  - paddle_width  - playing_field_boundery - 3 )
  y_paddle_limit_up = y_paddle_limit_down
  x_paddle_limit_left = ( playing_field_boundery + 3 )
  #
  # Playing field design
  # TODO:  A checkerboard would be a nice background.
  background( background_color )
  @border = border(
    # TODO:  Is there a dashed stroke?
    playing_field_color,
    :margin => playing_field_boundery,
  )
  ball_bounces = 0
  # Computer paddle sarting position.  It tries to follow the ball.
  # This doesn't matter much, since as soon as the game begins and the ball moves, the computer paddle will move appropriately.
  computer_x = 10
  computer_y = 10
  # Player paddle starting position.  It follows the mouse.
  # This doesn't matter much, since as soon as the user's mouse enters the window the paddle will move appropriately.
  player_x = x_paddle_limit_right
  player_y = y_paddle_limit_down
  @computer_paddle = (
    rect(
      computer_x,
      computer_y,
      paddle_width,
      paddle_height,
      :stroke => computer_paddle_stroke,
      :fill => computer_paddle_fill,
      :curve => computer_paddle_curve,
    )
  )
  @player_paddle = (
    rect(
      player_x,
      player_y,
      paddle_width,
      paddle_height,
      :stroke => player_paddle_stroke,
      :fill => player_paddle_fill,
      :curve => player_paddle_curve,
    )
  )
  # A ball appears (left-top side) and moves smoothly to right-bottom side at 20 frames per second.
  ball_x = playing_field_boundery + ( ball_radius / 2 )
  ball_y = playing_field_boundery + ball_radius + paddle_height - 2
  @ball = (
    oval(
      :left => ball_x,
      :top => ball_y,
      :radius => ball_radius,
      :fill => ball_fill,
      :stroke => ball_stroke,
    )
  )
  #
  # 2. Show two paddles and a ball
  # Allocate computer paddle on the top (immobile yet).
  @computer_paddle.move( computer_x, computer_y )
  # Allocate player's (your) paddle on the bottom.
  @player_paddle.move( player_x, player_y )
  # Ball
  # (A ball appears) left-top side and moves smoothly to right-bottom side at 20 frames per second.
  @ball.move( ball_x, ball_y )
  #
  # A ball appears left-top side and (moves smoothly to right-bottom side at 20 frames per second).
  xdir = 1
  ydir = 1
  # Borrowed code.  I don't understand these numbers, but I'll keep them!  Perhaps this is the pixel height:width size ratio.
  xspeed = 8.4
  yspeed = 6.6
  #
  # For better ball_smoothness, decrease the ball speed and increase the animate speed.
  xspeed /= ball_smoothness
  yspeed /= ball_smoothness
  xspeed *= ball_speed
  yspeed *= ball_speed
  #
  animate_speed = 10 * ball_smoothness
  ball_x = self.width / 2
  ball_y = self.height / 2
  # the + 2 is for the stroke width of the ball and the stroke width of the border.
  size = ( ball_radius * 2 ) + 2
  @animation = animate( animate_speed ) do
    # Re-assert the paddle's limitations.  This notices if the window resizes.
    y_paddle_limit_down  = ( self.height - paddle_height - playing_field_boundery - 5 )
    x_paddle_limit_right = ( self.width  - paddle_width  - playing_field_boundery - 3 )
    y_paddle_limit_up = y_paddle_limit_down
    x_paddle_limit_left = ( playing_field_boundery + 3 )
    #
    ball_y_previous = ball_y || 0
    ball_x = ball_x + xspeed * xdir
    ball_y = ball_y + yspeed * ydir
    # TODO:  Deal with resizes catching the ball off-screen.  The ball will do odd things.
    # just reset the game?
    # pause the game?
    # Figure out when the last useful x/y ball coordinates were and reset to there and continue?
 
    # FIXME - there is a multi-bounce happening if the paddle clips through the ball.  This can happen with the computer or player paddle.
    # FIXME - it feels like the left side of the computer paddle is allowing a victory.  Check.
    # Lock-in the ball within the window
    # bottom/player side, check for a paddle collision
    # Have your paddle hit the ball.
    if    ( ball_y > self.height - playing_field_boundery - paddle_height - size and
            ball_x > player_x and
            ball_x < player_x + paddle_width
          ) then
      ball_bounces += 1
      # Change ball's speed and bounce angle when the ball is hit.
      # TODO:  Vary the ball angle a little bit, based on how the paddle was moving when the impact was made?
      #        This would require a complex rework of things, using my earlier ball angle ideas.
      #        But the gameplay feel would be superior.
      xspeed += 0.5
      yspeed += 0.5
      ydir *= -1
      #puts "bounced at #{ball_x.to_i},#{ball_y.to_i} - PLAYER"
    # top/computer side, check for a paddle collision
    elsif ( ball_y < 0 + playing_field_boundery + paddle_height + size and
            ball_x > computer_x and
            ball_x < computer_x + paddle_width
          ) then
      ball_bounces += 1
      # Change ball's speed and bounce angle when the ball is hit.
      # TODO:  Vary the ball angle a little bit, based on how the paddle was moving when the impact was made?
      #        This would require a complex rework of things, using my earlier ball angle ideas.
      #        But the gameplay feel would be superior.
      xspeed += 0.5
      yspeed += 0.5
      ydir *= -1
      #puts "bounced at #{ball_x.to_i},#{ball_y.to_i} - COMPUTER"
    # bottom/player side, check for a point
    elsif ball_y > self.height then
    #elsif ball_y > ( self.height - playing_field_boundery - size ) then
      #ydir *= -1
      end_game( ball_x, ball_y, ball_bounces )
      #puts "bounced at #{ball_x.to_i},#{ball_y.to_i}"
    # top/computer side, check for a point
    # The numbers are right, but it doesn't look right when animated.
    elsif ball_y < 0 then
    #elsif ball_y < ( 0 + playing_field_boundery + size ) then
      #ydir *= -1
      end_game( ball_x, ball_y, ball_bounces )
      # TODO:  End game
    # left/right, bounce the ball
    # Bounce a ball on the edge of the window.
    elsif (  ball_x > self.width - playing_field_boundery - size or
             ball_x < 0          + playing_field_boundery + size
          ) then
      xdir *= -1
      ball_bounces += 1
      #puts "bounced at #{ball_x.to_i},#{ball_y.to_i}"
    end
    # Move the ball
    @ball.move ball_x.to_i, ball_y.to_i
    # Computer's paddle synchronizes with the ball movement.
    # TODO:  Limit the computer paddle within the play field the same way the player's paddle needs limiting.
    @computer_paddle.move( computer_x, computer_y )
    # This needs to be a little fuzzy, to make the game play good.
    if ball_y < ball_y_previous and ball_y < self.height / 1.5 then
      rand = ( Random.rand( 2 ) + 2 )
      if    computer_x + ( paddle_width / 2 ) > ball_x then
        computer_x -= ( computer_speed - Random.rand( computer_randomness ) / rand )
      elsif computer_x + ( paddle_width / 2 ) < ball_x then
        computer_x += ( computer_speed + Random.rand( computer_randomness ) / rand )
      end
    end
  end
  #
  # Your paddle synchronizes with the mouse movement.
  motion do | mouse_x, mouse_y |
    append do
      @player_paddle.move( player_x, player_y )
    end
    #
    player_x = mouse_x
    # Restrict paddle x
    if player_x > x_paddle_limit_right then player_x = x_paddle_limit_right end
    if player_x < x_paddle_limit_left  then player_x = x_paddle_limit_left  end
    #
    player_y = mouse_y
    # Restrict paddle y
    if player_y > y_paddle_limit_down then player_y = y_paddle_limit_down end
    if player_y < y_paddle_limit_up   then player_y = y_paddle_limit_up   end
  end
  keypress do |k|
    # Q or ^c to quit.
    if k         == 'Q'          then exit end
    if k.inspect == ':control_c' then exit end
    # TODO:  Smoother keyboard paddle control, via more frequent keyboard checking.  This is likely restricted by the operating system / BIOS settings.
    # FIXME:  Upon first keypress it hops to the left.
    ## It should know its current position -- and not be based on the mouse coordinates (unless the mouse has actually entered the playing field once).
    if k.inspect == ':left'  then @player_paddle.move( player_x -= 10, player_y ) end
    if k.inspect == ':right' then @player_paddle.move( player_x += 10, player_y ) end
    p k
  end
end