require 'green_shoes'

Shoes.app do
  p = para Time.now.to_s 
  animate 25 do
    time = Time.now.to_s
    p.text = time
    p time
    a_code_very_slow()
  end
  
  def a_code_very_slow()
    p '+a_code_very_slow() started'
    sleep(1)
    p '-a_code_very_slow() finished'
  end
end