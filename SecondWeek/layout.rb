require 'green_shoes'
Shoes.app width: 380, height: 550 do
  flow do
    tagline 'IDEA ONE', width:380
    image 'http://shoesrb.com/manual/static/shoes-icon.png', width: 100, height: 100
    flow width: width-100 do
      para 'Text A', "\n", width:280, left:100
      para 'Text B   '
      para  'flow ' * 27
    end
  end
 
  tagline 'IDEA TWO'
  flow do
    stack width: 100 do
      para
      image 'http://shoesrb.com/manual/static/shoes-icon.png', width: 100, height: 100
    end
    flow width: width-100 do
      para 'Text A', "\n"
      para 'Text B   '
      para  'flow ' * 27
    end
  end
 
  tagline 'IDEA THREE'
  flow do
    para 'Text A', "\n"
    image 'http://shoesrb.com/manual/static/shoes-icon.png', width: 100, height: 100
    flow width: width-100 do
      para 'Text B   '
      para  'flow ' * 27
    end
  end
end