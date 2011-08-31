require 'green_shoes' 

Shoes.app do

  #background black
  #title 'test', fill: white, stroke: green
  begin
  	title fg(bg('test', yellow), red)
  rescue Exception => e
  	alert e
  end
end