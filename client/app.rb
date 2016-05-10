require_relative 'client'

include Client

payload = { foo: "bar" }

puts "=====JSON====="
json_request(payload)
puts "=====MessagePack====="
msgpack_request(payload)
puts "=====Protocol Buffers====="
protobuf_request(payload)
