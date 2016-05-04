require_relative 'client'

include Client

message = {foo: "bar"}

puts "=====JSON====="
json_request(message)
puts "=====MessagePack====="
msgpack_request(message)
puts "=====Protocol Buffers====="
protobuf_request(message)
