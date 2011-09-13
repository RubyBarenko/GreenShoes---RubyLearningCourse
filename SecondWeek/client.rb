#chat.rb
require 'green_shoes'
 
class Client
  def initialize(server = 'localhost', port = 2000)
    @socket = TCPSocket.open(server, port)
  end
  
  def recieve
    @socket.readline
  end
  
  def send(text)
    @socket.puts text
  end
end
 
def get_chats
  while true
    if text = @client.recieve
      @text.text += text
    end
  end
end
 
def send_chats
  @client.send @edit_line.text
  @edit_line.text = ''
  @edit_line.focus
end
 
Shoes.app(:height => 400, :width => 400) do
  stack do
    @text = edit_box :height => 370, :width => 390, :state => "readonly"
  end
    
  stack do
    flow do
      @submit = button "submit", :width => 100 do
        send_chats
      end
      @edit_line = edit_line :width => 270
      @edit_line.focus
    end
  end
  
  @client = Client.new("10.254.254.12")
  Thread.start {get_chats}
  
  keypress do |k|
    if k.inspect == '"\n"'
      send_chats
    end
  end
end