#chat_and_client.rb
require 'socket'
require 'green_shoes'  #####
 
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
 
def print_onscreen
  @client.send @edit_line.text  #####
  #@text.text = @text.text + @edit_line.text + "\n"
  @text.text += @client.recieve  #####
  @edit_line.text = ''
  @edit_line.focus
end
 
Shoes.app(:height => 400, :width => 400) do
  stack do
    @text = edit_box :height => 370, :width => 400, :state => 'readonly'  #####
  end
    
  stack do
    flow do
      @submit = button "submit", :width => 99, :height => 28 do  #####
        print_onscreen
      end
      @edit_line = edit_line :width => 300
    end
  end
 
  @client = Client.new  #####
  
  keypress do |k|
    if k.inspect == '"\n"'
      print_onscreen
    end
  end
end
 