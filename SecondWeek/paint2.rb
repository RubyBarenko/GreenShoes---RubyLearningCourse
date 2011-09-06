#only on red shoes
Shoes.app do
  flag = nil
  motion do |x, y|
    b, x, y = mouse
    line @x, @y, x, y if b == 1
    @x, @y = x, y
  end
  button 'Take a snapshot' do
    _snapshot filename: './drawing.pdf', format: :pdf
  end
end