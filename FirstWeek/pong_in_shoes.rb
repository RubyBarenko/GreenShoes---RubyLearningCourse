require 'green_shoes'

class Position
  def initialize(ball, objects=[], limits = [400,400])
    @position = [0.0,0.0]
    @velocity = [Math.sqrt(1200), Math.sqrt(1200)]
    @limits= limits
    @time = Time.now
    @ball = ball
    @ball_size = ball.width, ball.height
    @objects = objects
    @collided = ball
  end

  def start()
    @time = Time.now
  end

  def current()
    delta = Time.now - @time
    @time = Time.now
    get_x(delta)
    get_y(delta)
    
    @objects.each do |obj|
      if @collided != obj && Position.collided_rect?(@ball, obj) then
        @position[1] = @position[1]
        @velocity = @velocity[0] * 1.3 , @velocity[1] * 1.3
        @velocity[1] = - @velocity[1]
        @collided = obj
      end
    end
    @position
  end

  def get_x(delta)
    @position[0] = @position[0] + @velocity[0] * delta
    if @position[0] &lt; 0 then
      @position[0] = -@position[0]
      @velocity[0] = -@velocity[0]
    elsif @position[0] + @ball_size[0] > @limits[0] then
      @position[0] = (@limits[0] - @ball_size[0]) * 2 - @position[0]
      @velocity[0] = -@velocity[0]
    end
  end

  def get_y(delta)
    @position[1] = @position[1] + @velocity[1] * delta
    if @position[1] &lt; 0 then
      @champion = 'Player'
    elsif @position[1] + @ball_size[1] > @limits[1] then
      @champion = 'PC'
    end
  end

  def Position.collided_rect?(circle, rect)
    if circle.top + circle.width >= rect.top && circle.top &lt;= rect.top + rect.height then
      if circle.left >= rect.left && circle.left + circle.width &lt;= rect.left + rect.width then
        return true;
      end
    end
    false
  end

  def Position.center(obj)
    [obj.left + obj.width/2, obj.top - obj.height/2]
  end
  
  def giveTheChampion()
    @champion
  end
end

Shoes.app title:"Pong in Shoes (v0.1)", width:400, height:400 do
  background black
  paddle_size = 80
  stroke rgb(1,1,0)
  fill rgb(0.6, 0.6, 0)
  @player = rect(left:(self.width - paddle_size)/2,top:380, width:paddle_size, height:10)
  @pc = rect(left:(self.width - paddle_size)/2, top:10, width:paddle_size, height:10)

  @ball = oval(0,100,6)
  @ball_position = Position.new(@ball, [@player, @pc])

  @motion = motion do |mouse_x, mouse_y|
    case 
      when (@player.width/2) >= mouse_x then
        @player.move 0, @player.top
      when (self.width - @player.width/2) &lt;= mouse_x then
        @player.move self.width - @player.width, @player.top
      else
        @player.move mouse_x - @player.width/2, @player.top
    end
  end

  @ball_position.start
  #velocidade movimento pc
  @pc_animate = animate 25 do
    new_position = @ball_position.current
    @ball.left, @ball.top = new_position #@ball_position.current

    @velocity = 4
    ball_x = @ball.left + @ball.width/2
    pc_x = @pc.left + @pc.width/2
    
    if pc_x - @velocity > ball_x then
      pc_x = @pc.left - @velocity
      pc_x = 0 if pc_x &lt; 0
      @pc.move pc_x, @pc.top
    elsif pc_x + @velocity &lt; ball_x
      pc_x = @pc.left + @velocity
      pc_x = self.width - @pc.width if pc_x > self.width - @player.width
      @pc.move pc_x, @pc.top
    end
    
    unless @ball_position.giveTheChampion().nil? then
      alert "#{@ball_position.giveTheChampion()} Wins!"
      @pc_animate.stop
    end
  end

end
