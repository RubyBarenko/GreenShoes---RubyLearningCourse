require 'green_shoes'

Shoes.app title:'Calc', width:300, height:40 do
  first = edit_line   width:50, height:20, left:10 do |e| 
    @change_event.call
  end
  para ' X',          width:20, height:20, left:80
  second = edit_line  width:50, height:20, left:100 do |e| 
    @change_event.call
  end
  para ' =',          width:20, height:20, left:140
  value = para '',    width:100, height:20, left:180

  @change_event = Proc.new do 
    unless first.text.nil? or second.text.nil? then
      value.text = first.text.to_i * second.text.to_i
    end
  end  
end
