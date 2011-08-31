# 	require 'green_shoes' 
Shoes.app do ball = oval 0, 0, 10
	animate(20){|i| ball.move i*5, i*7}
end