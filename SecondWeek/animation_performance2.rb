require 'green_shoes'
 
Shoes.app do
  p = para Time.now.to_s
  @vs  = para
  @t = Thread.new{}  
  
  animate do
    time = Time.now.to_f
    p.text = time
    unless @t.alive?
      @t = Thread.new{a_code_very_slow()}
    end
  end
  
  def a_code_very_slow()
    @vs.text = '+a_code_very_slow() started'
    sleep(5)
    @vs.text = '-a_code_very_slow() finished'
    sleep(2)
  end
end