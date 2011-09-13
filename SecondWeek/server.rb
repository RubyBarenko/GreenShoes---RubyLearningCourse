#ChatSvr.rb
require 'socket'
 
class ChatSvr
  def initialize
    @server = TCPServer.new('10.254.254.12', 2000)
    @clients = []
  end
  
  def run
    while true
      if client = @server.accept
        @clients << client
        Thread.start {client_chat(client)}
      end
    end
  end
  
  def client_chat(client)
    continue = true
    while continue
      data = ''
      data = client.gets
      #client.puts "%s: %s" % [client.peeraddr[2], data]
      @clients.each { |cli| cli.puts "%s: %s" % [client.peeraddr[2], data] }
      puts "%s: %s" % [client.peeraddr[2], data]
      continue = false if data.chomp == "quit"
    end
  end
end
 
c = ChatSvr.new
c.run