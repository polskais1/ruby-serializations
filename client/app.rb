require_relative 'client'

include Client

puts "=====JSON====="
json_request({foo: "bar"})
puts "=====MessagePack====="
msgpack_request({foo: "bar"})
puts "=====Protocol Buffers====="
protobuf_request({foo: "bar"})
