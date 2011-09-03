require 'green_shoes'

WIDTH, HEIGHT = 400, 400
LEVEL = {Easy:8, Normal:12, Hard:16, Impossible:20}
 
module PongGame 
  def index
    background black
    stack do
      flow do
        stroke :white
        fill :red
        @level = list_box items:LEVEL.keys, choose: LEVEL.keys[1], width:280 #width:0.75 => button will be on the list
        @play = button 'Play', left:400, width:0.25 do #width:100 not works
          @play.state, @level.state = 'disabled', 'disabled'
          game_start
        end
      end
    end
  end
  
  def game_start
    nostroke; fill "#5F5" .. "#000" # dont works on red shoes.... How can I detect if I'm using green or red shoes?
    @player1 = @player1.show rescue paddle(name:'Player1', x:WIDTH/2 - 40, y:HEIGHT - 18)
    nostroke; fill "#000".."#F55" # dont works on red shoes....
    @player2 = @player2.show rescue paddle(name:'Computer', x:WIDTH/2 - 40, y:30)

    fill rgb(0.9, 0.9, 0.9, 0.5); stroke rgb(0.9, 0.9, 0.9, 0.2); strokewidth 0.25
    @ball = @ball.show rescue ball(radius:8,limits:[WIDTH,HEIGHT], paddle_bottom:@player1,paddle_up:@player2)

    @champion = @champion.hide rescue (title "", top:200, align:'center')

    motion {|x, y| @player1.slice(x)}

    @ball.reset

    game = animate 25 do
      @ball.foward

      p0 = @player2.center.real
      delta = (@ball.center - @player2.center).real
      delta = delta > LEVEL[@level.text] ? LEVEL[@level.text] : delta
      @player2.slice(p0 + delta)

      unless @ball.scored_by.nil?
        @champion.text = fg("#{@ball.scored_by.name} wins!", white)
        @champion.show
        @ball.hide; @player1.hide; @player2.hide
        @play.state, @level.state = nil, nil
        game.stop
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

      def center(); Complex(left+width/2, top+height/2); end
    end

    p.limit = opts[:limit]||=WIDTH
    p.name = opts[:name]||=''
    p
  end
  
  def ball(opts={x:0, y:0, radius:6, limits:[WIDTH,HEIGHT], paddle_bottom:nil, paddle_up:nil})
    b = oval(opts[:x]||=0, opts[:y]||=0, opts[:radius]||=6)
    class << b
      attr_accessor :limits, :paddle_up, :paddle_bottom, :radius
      attr_reader :scored_by

      def move_step(complex_delta) #moviment relative to current position
        pos = center

        unless (0 + radius .. @limits[0] - radius) === pos.real then #vertical borders
          complex_delta = complex_delta -2*complex_delta.real
        end

        if pos.imag + radius >= @paddle_bottom.top then #paddlers
          if (@paddle_bottom.left .. @paddle_bottom.left + @paddle_bottom.width) === pos.real then
            complex_delta = collision_reflect(complex_delta.conj * 1.1, @paddle_bottom) if complex_delta.imag > 0
          end
        elsif pos.imag - radius <= @paddle_up.top + @paddle_up.height then
          if (@paddle_up.left .. @paddle_up.left + @paddle_up.width) === pos.real then
            complex_delta = collision_reflect(complex_delta.conj * 1.1, @paddle_up) if complex_delta.imag < 0
          end
        end

        unless (0 .. @limits[1]) === pos.imag then #champion
          @scored_by = (pos.imag < @limits[1]/2 ? paddle_bottom : paddle_up)
        end

        pos = pos + complex_delta

        move(pos.real - radius, pos.imag - radius)
        @last_move = complex_delta
      end

      def collision_reflect(complex_delta, paddle)
        dx = (paddle.center.real - center.real)*10/paddle.width
        x = complex_delta.real - dx
        parc = complex_delta.magnitude**2 - x**2
        y = Math::sqrt(parc.abs) * (complex_delta.imag/complex_delta.imag.abs)
        Complex(x,y)
      end

      def center(); Complex(left+width/2, top+height/2); end

      def foward(); move_step(@last_move); end

      def scored_by=(player)
        @scored_by = player
      end
      
      def reset()
        move(limits[0]/2, limits[1]/2)
        @scored_by, @last_move = nil, nil
        move_step(Complex(0,-5))
      end
    end
    b.limits = opts[:limits]||=[WIDTH,HEIGHT]
    b.paddle_up, b.paddle_bottom = opts[:paddle_up]||={}, opts[:paddle_bottom]||={}
    b.radius = b.width/2
    b
  end
end
 
Shoes.app title:'Pong in Shoes (v.0.2)', width:WIDTH, height:HEIGHT do
  extend PongGame 
  index
end