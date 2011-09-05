require 'green_shoes'
require 'matrix'

module Fly
  def movement(dot)
    dot.vel ||= Vector[0,0]
    dot.vel += close_lamp(dot) if rand(2).zero?
    dot.vel += dont_collide(dot) if rand(2).zero?
    dot.vel += vel_ajust(dot)
    dot.vel += pos_ajust(dot)
    dot.vel
  end
  def close_lamp(dot)
    ds = @lamp.pos - dot.pos
    (ds) * 0.1
  end
  def dont_collide(dot)
    c = Vector[0, 0]
    @dots.each do |d|
      dist = d.pos - dot.pos
      (c -= d.pos - dot.pos) if (d != dot and dist[0].to_i.abs < 10 and dist[1].to_i.abs < 10)
    end
    c
  end
  def vel_ajust(dot)
    c = @dots.collect{|d| d.vel}.inject{|i, j| i + j} - dot.vel
    c *= 1 / (@dots.size - 1.0)
    ((c - dot.vel) * (1 / 16.0))
  end
  def pos_ajust (dot)
    c = @dots.collect{|d| d.pos}.inject{|i, j| i + j} - dot.pos
    c *= 1 / (@dots.size - 1.0)
    (c - dot.pos) * 0.005
  end
end

class Bug 
  attr_accessor :vel, :pos
  def initialize(scope)
    scope.nostroke; scope.fill scope.rgb(rand(240),rand(240),rand(240));
    @oval = scope.oval left:rand(WIDTH-4), top:rand(HEIGHT-4), radius:4
    @pos = Vector[@oval.left,@oval.top]
    @vel = Vector[0,0]
  end
  def move(pos)
    @oval.move @pos[0],@pos[1]
  end
end

class Lamp
  attr_accessor :pos
  def initialize(scope, x, y)
    @pos=Vector[x,y]
    scope.fill '#330'..'#000'; scope.stroke '#550' .. '#000';
    scope.rect top:y, height:(HEIGHT-y), left:x, width:10
    scope.fill '#FFF'..'#FF0'; scope.stroke '#FFF' .. '#BB0';
    scope.oval top:(y-30), height:60, left:x-15, width:40
  end
end



WIDTH, HEIGHT = 800, 600

Shoes.app title:'Drawing performance test', width:WIDTH, height:HEIGHT do
  extend Fly
  background "#003" .. "#000"

  population=30
  @dots = []
  (population/2).times { @dots << Bug.new(self) }
  @lamp = Lamp.new(self, WIDTH/2,HEIGHT/2)
  (population/2).times { @dots << Bug.new(self) }

  animate 25 do
    @dots.each do |dot|
      dot.pos = dot.pos + movement(dot)
      dot.move dot.pos
    end
  end
end