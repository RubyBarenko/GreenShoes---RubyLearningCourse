require 'green_shoes'
WIDTH, HEIGHT = 800, 600

Shoes.app title:'Drawing performance test', width:WIDTH, height:HEIGHT do
  population=10

  dots = []

  nostroke
  population.times do
    fill rgb(rand(250),rand(250),rand(250));
    o=oval left:rand(WIDTH-4), top:(rand(HEIGHT-4)), radius:4
    dots << o
  end

  def play

  end
end