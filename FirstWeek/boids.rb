# gallery10.rb
# http://www.vergenet.net/~conrad/boids/pseudocode.html
require 'matrix'
require 'boids_image'
require 'boids_rules'

Shoes.app :title => 'A Very Simple Boids v0.1', width:800, height:600 do
  extend Rules
  background rgb(0.5,0.5,0.5,0.5)
  @boids = []
  N.times do
    x, y = rand(800), rand(600)
    vx, vy = rand(2), rand(2)
    @boids << image('./boid.gif', 
      :left => x, :top => y, :pos => Vector[x, y], :vel => Vector[vx, vy])
  end

  animate 30 do
    @boids.each do |boid|
      boid.vel =  boid.vel + 
                  rule1(boid) + 
                  rule2(boid) + 
                  rule3(boid) + 
                  rule4(boid)
      boid.pos = boid.pos + boid.vel
      boid.move boid.x, boid.y
    end
  end
end