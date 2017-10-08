require 'socket'

# Factorio RCon class
class RCon

  attr_accessor :server, :password, :port

  def initialize(server: "localhost", port: 25575, password: )
    @server = server
    @port = port
    @password = password.encode("UTF-8")
  end

  def random_seed
    Random.rand(0..999)
  end

  def socket
    @socket ||= TCPSocket.new(@server, @port)
  end

  def command_type
    { login: 3, command: 2 }
  end

  def packet_info(request_id:, packet_type:, payload:)
    [ request_id, packet_type, payload ].pack("i<i<A*xx")
  end

  def packet_length(packet_body:)
    [ packet_body.length ].pack("i<")
  end

  def login(request_id:)
    login_packet = command_type[:login]
    body = packet_info(request_id: request_id, packet_type: login_packet, payload: @password)
    packet_length = packet_length(packet_body: body)
    socket.write(packet_length + body)
  end

  def send_command(request_id:, command:)
    command_packet = command_type[:command]
    body = packet_info(request_id: request_id, packet_type: command_packet, payload: command.encode("UTF-8"))
    packet_length = packet_length(packet_body: body)
    socket.write(packet_length + body)
  end

  def get_returned_length
    socket.read(4).unpack("i<").first
  end

  def get_returned_data(length:)
    socket.read(length)
  end

  def get_id(returned_data:)
    id, _packet_type = returned_data[0,8].unpack("i<i<")
    id
  end

  def get_packet_type(returned_data: )
    _id, packet_type = returned_data[0,8].unpack("i<i<")
    packet_type
  end

  def disconnect
    socket.close
  end

  # def connected?

end
