require 'sinatra/base'
require 'json'
require 'msgpack'
require 'protobuf'
class Server < Sinatra::Base

  class ProtoMessage < Protobuf::Message
    optional :string, :foo, 1
  end

  post '/json' do
    # Decode using JSON
    @@start_decode_time = time_in_microseconds
    decoded_request = JSON.parse(request.body.string)
    @@end_decode_time = time_in_microseconds


    # Encode using JSON
    @@start_encode_time = time_in_microseconds
    encoded_response = decoded_request.to_json
    @@end_encode_time = time_in_microseconds

    encoded_response
  end

  post '/msgpack' do
    content_type "application/msgpack"
    # Decode using MessagePack
    @@start_decode_time = time_in_microseconds
    decoded_request = MessagePack.unpack(request.body.string)
    @@end_decode_time = time_in_microseconds


    # Encode using MessagePack
    @@start_encode_time = time_in_microseconds
    encoded_response = MessagePack.pack(decoded_request)
    @@end_encode_time = time_in_microseconds

    encoded_response
  end

  post '/protobuf' do
    content_type "application/msgpack"
    @@start_decode_time = time_in_microseconds
    decoded_request = ProtoMessage.decode(request.body.string)
    @@end_decode_time = time_in_microseconds

    @@start_encode_time = time_in_microseconds
    encoded_response = ProtoMessage.new(decoded_request).encode
    @@end_encode_time = time_in_microseconds

    encoded_response
  end

  get '/benchmark' do
<<<<<<< HEAD
    content_type "application/json"
=======
    content_type :json
>>>>>>> 2341399e0dc2a0969358db13967a46c8683bcc31
    decode_time = @@end_decode_time.to_i - @@start_decode_time.to_i
    encode_time = @@end_encode_time.to_i - @@start_encode_time.to_i
    { decode_time: decode_time, encode_time: encode_time }.to_json
  end

  def time_in_microseconds
    Time.now.strftime '%s%6N'
  end

  run!
end
