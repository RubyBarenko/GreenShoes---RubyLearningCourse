Shoes.app do
  r=  oval 100, 50, 200, fill: red
  oval 50, 150, 200, fill: green
  b=  oval 150, 150, 200, fill: blue

  group = image do
    r
    b
  end

  motion do
    b, x, y = mouse
    group.move x-200, y-200 if b == 1
  end
end