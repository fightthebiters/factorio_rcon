#!/usr/bin/env ruby
#

$: << './lib'

require 'pry'
require 'rcon'

r = RCon.new(server: "127.0.0.1", password: "password_for_test_not_real")

request_id = r.random_seed

r.login(request_id: request_id)
# binding.pry

# get auth ID, -1 means fail
returned_length = r.get_returned_length
returned_data = r.get_returned_data(length: returned_length)
id = r.get_id(returned_data: returned_data)

if id == -1
  puts "Failed to login"
  r.socket.close
end

binding.pry

request_id = r.random_seed

r.send_command(request_id: request_id, command: "/evolution")

returned_length = r.get_returned_length
returned_data = r.get_returned_data(length: returned_length)
id, packet_type = r.get_packet_type(returned_data: returned_data)
message = returned_data[8..-3]

binding.pry


