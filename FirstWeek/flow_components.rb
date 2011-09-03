=begin
Hi Rafael,

Great work! Thank you for taking the time to find the differences between Red and Green. cool

Okay, let me explain a little bit.

1st: Green Shoes needs a slot explicitly to calculate widht and height.
This is one of restrictions for now. So, please add a slot like this.

require 'green_shoes'
Shoes.app do
  stack do
    button 'hello', width: 0.5
    list_box width: 0.5
  end
end



2nd: Green Shoes button needs both :width and :height at a time.
This is a bug. But sorry, can't fix soon. So, please add both like this.

require 'green_shoes'
Shoes.app do
  button 'hello', width: 300, height: 28
end



3rd: Green Shoes TextBlock needs :width size explicitly.
This is one of restrictions for now. Look at this page.
So, try to add :width size in the flow block like this:

para "Size: #{l1.width}", width: 100



=end

require 'green_shoes'


Shoes.app width:600, height:800 do
  subtitle 'On Shoes'
  para strong 'list_box with Fixnum width'
  l1=list_box items:%w{first second third}, choose:'first', width: 200
  para "Size: #{l1.width}"
  
  para strong 'list_box with Float width'
  #1: this not works here
  l2=list_box items:%w{first second third}, choose:'first', width: 0.5
  para "Size: #{l2.width}"
  
  para strong 'list_box with Float width'
  #2: this not works here
  b1=button 'First', width:0.5
  para "Size: #{b1.width}"

  para strong 'list_box with Fixnum width'
  #3: this not works here
  b2=button 'Second', width:300
  para "Size: #{b2.width}"

  subtitle 'On flow'
  flow do
    strong 'list_box with Fixnum width'
    l1=list_box items:%w{first second third}, choose:'first', width: 200
    para "Size: #{l1.width}"
    
    para strong 'list_box with Float width'
    #1: but works here.... why?
    l2=list_box items:%w{first second third}, choose:'first', width: 0.5
    para "Size: #{l2.width}"
    
    para strong 'list_box with Float width'
    #2: but works here.... why?
    b1=button 'First', width:0.5
    para "Size: #{b1.width}"
  
    para strong 'list_box with Fixnum width'
    #3: its need the width AND height to works
    b2=button 'Second', width:300, height: 20
    para "Size: #{b2.width}"
  end

  subtitle 'On stack'
  stack do
    para strong 'list_box with Fixnum width'
    l1=list_box items:%w{first second third}, choose:'first', width: 200
    para "Size: #{l1.width}"
    
    para strong 'list_box with Float width'
    #1: too works here.... why?
    l2=list_box items:%w{first second third}, choose:'first', width: 0.5
    para "Size: #{l2.width}"
    
    para strong 'list_box with Float width'
    #2: too works here.... why?
    b1=button 'First', width:0.5
    para "Size: #{b1.width}"
  
    para strong 'list_box with Fixnum width'
    #3: its need the width AND height to works
    b2=button 'Second', width:200, height: 20
    para "Size: #{b2.width}"
  end
end
