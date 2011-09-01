require 'green_shoes'

WIDTH, HEIGHT = 400, 400

class PongGame < Shoes
  url '/', :index

  def index
    background black
    game_start
#  rescue Exception => e
#    alert e
#    throw e
  end

  def game_start  
    @info_panel = para "", align:'center', size:10
    
    stroke rgb(1,1,0); fill rgb(0.6, 0.6, 0)
    @player1 = paddle(name:'Player1', x:WIDTH/2 - 40, y:HEIGHT - 18)
    @player2 = paddle(name:'Computer', x:WIDTH/2 - 40, y:22)

    stroke rgb(0.2,1,0); fill rgb(0.3, 0.7, 0)
    @ball = ball(x:WIDTH/2,y:HEIGHT/2,radius:6,limits:[WIDTH,HEIGHT], paddlers:[@player1,@player2])
 
    motion {|x, y| @player1.slice(x)}

    @ball.move_step(0,-5);
    t0 = Time.now.to_i
    @game = animate 10 do
      @ball.foward
      @info_panel.text = fg("Score: #{Time.now.to_i - t0}",yellow)
      unless @ball.scored_by.nil?
        alert "#{@ball.scored_by.name} wins!"
        @game.stop
      end
    end
  end

  def paddle(opts={name:'', x:0, y:0, width:80, height:8, limit:WIDTH})
    p=rect(opts[:x]||=0,opts[:y]||=0,opts[:width]||=80,opts[:height]||=8)
    
    class << p
      attr_accessor :name, :limit
      
      def slice(x)
        px = x
        if width/2 >= x then px = 0
        elsif (limit - width/2) <= x then px = limit - width
        else px = x - width/2
        end
        move px, top
      end
      
      def center()
        [left+width/2, top+height/2]
      end
      
      def reflect_ajust(object)
        delta = center[0] - object.center[0]
        (1 - Math.sqrt(1-(2*delta.abs/width)**Math::E)) *(delta/delta.abs)
      end
    end
    
    p.limit = opts[:limit]||=WIDTH
    p.name = opts[:name]||=''
    p.show #bugfix -> first call of rect#top() returns zero
    p
  end

  def ball(opts={x:0, y:0, radius:6, limits:[WIDTH,HEIGHT], paddlers:{}})
    b = oval(opts[:x]||=0, opts[:y]||=0, opts[:radius]||=6)
    
    class << b
      attr_accessor :limits, :paddlers
      attr_reader :scored_by
      
      def move_step(vx,vy) #moviment relative to current position
        px, py = left + vx, top + vy

        @paddlers.each do |paddler|
          px, py, vx, vy = collision_reflect vx, vy, paddler if collision? paddler
        end
        
        if px < 0 then
          px, vx = -px, -vx
        elsif px + width > @limits[0] then
          px, vx = (2*(@limits[0] - width) - px), -vx
        end

        if py < 0 then
          @scored_by = @paddlers[0]
        elsif py + height > @limits[1] then
          @scored_by = @paddlers[1]
        end

        move(px, py)
        @last_move = vx,vy
      end
      
      def collision_reflect(vx, vy, paddler)
        ajust = paddler.reflect_ajust(self)
        p ajust
        [left + vx + ajust, top - vy, vx,-vy]
      end
      
      def collision?(paddler)
        if top + height >= paddler.top && top <= paddler.top + paddler.height then
          if left >= paddler.left && left + width <= paddler.left + paddler.width then
            return true
          end
        end
        false
      end
      
      def center()
        [left+width/2, top+height/2]
      end
      
      def foward() #go ahead
        move_step(@last_move[0],@last_move[1])
      end
      
      def scored_by=(player)
        @scored_by = player
        def self.foward(); end
      end
    end
    
    b.limits = opts[:limits]||=[WIDTH,HEIGHT]
    b.paddlers = opts[:paddlers]||={}
    b
  end
end

Shoes.app title:'Pong in Shoes (v.0.2)', width:WIDTH, height:HEIGHT







# class BallPosition
#   def initialize(ball, objects=[], limits = [400,400])
#     @position = [0.0,0.0]
#     @velocity = [Math.sqrt(1200), Math.sqrt(1200)]
#     @limits= limits
#     @time = Time.now
#     @ball = ball
#     @ball_size = ball.width, ball.height
#     @objects = objects
#     @collided = ball
#   end

#   def start()
#     @time = Time.now
#   end

#   def current()
#     delta = Time.now - @time
#     @time = Time.now
#     get_x(delta)
#     get_y(delta)
    
#     @objects.each do |obj|
#       if @collided != obj && BallPosition.collided_rect?(@ball, obj) then
#         @position[1] = @position[1]
#         @velocity = @velocity[0] * 1.3 , @velocity[1] * 1.3
#         @velocity[1] = - @velocity[1]
#         @collided = obj
#       end
#     end
#     @position
#   end

#   def get_x(delta)
#     @position[0] = @position[0] + @velocity[0] * delta
#     if @position[0] &lt; 0 then
#       @position[0] = -@position[0]
#       @velocity[0] = -@velocity[0]
#     elsif @position[0] + @ball_size[0] > @limits[0] then
#       @position[0] = (@limits[0] - @ball_size[0]) * 2 - @position[0]
#       @velocity[0] = -@velocity[0]
#     end
#   end

#   def get_y(delta)
#     @position[1] = @position[1] + @velocity[1] * delta
#     if @position[1] &lt; 0 then
#       @champion = 'Player'
#     elsif @position[1] + @ball_size[1] > @limits[1] then
#       @champion = 'PC'
#     end
#   end

#   def self.collided_rect?(circle, rect)
#     if circle.top + circle.width >= rect.top && circle.top &lt;= rect.top + rect.height then
#       if circle.left >= rect.left && circle.left + circle.width &lt;= rect.left + rect.width then
#         return true;
#       end
#     end
#     false
#   end

#   def self.center(obj)
#     [obj.left + obj.width/2, obj.top - obj.height/2]
#   end
  
#   def giveTheChampion()
#     @champion
#   end
# end

# Shoes.app title:"Pong in Shoes (v0.1)", width:400, height:400 do
#   background black
#   paddle_size = 80
#   stroke rgb(1,1,0)
#   fill rgb(0.6, 0.6, 0)

#   @player = rect(left:(self.width - paddle_size)/2,top:380, width:paddle_size, height:10)
#   @pc = rect(left:(self.width - paddle_size)/2, top:10, width:paddle_size, height:10)

#   @ball = oval(0,100,6)
#   @ball_position = BallPosition.new(@ball, [@player, @pc])

#   @motion = motion do |mouse_x, mouse_y|
#     case 
#       when (@player.width/2) >= mouse_x then
#         @player.move 0, @player.top
#       when (self.width - @player.width/2) &lt;= mouse_x then
#         @player.move self.width - @player.width, @player.top
#       else
#         @player.move mouse_x - @player.width/2, @player.top
#     end
#   end

#   @ball_position.start
#   #velocidade movimento pc
#   @pc_animate = animate 25 do
#     new_position = @ball_position.current
#     @ball.left, @ball.top = new_position #@ball_position.current

#     @velocity = 4
#     ball_x = @ball.left + @ball.width/2
#     pc_x = @pc.left + @pc.width/2
    
#     if pc_x - @velocity > ball_x then
#       pc_x = @pc.left - @velocity
#       pc_x = 0 if pc_x &lt; 0
#       @pc.move pc_x, @pc.top
#     elsif pc_x + @velocity &lt; ball_x
#       pc_x = @pc.left + @velocity
#       pc_x = self.width - @pc.width if pc_x > self.width - @player.width
#       @pc.move pc_x, @pc.top
#     end
    
#     unless @ball_position.giveTheChampion().nil? then
#       alert "#{@ball_position.giveTheChampion()} Wins!"
#       @pc_animate.stop
#     end
#   end

# end