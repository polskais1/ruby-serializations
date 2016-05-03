require 'sinatra/base'
require 'json'
require 'msgpack'
class Server < Sinatra::Base
  # Benchmarks
  @@start_encode_time
  @@end_encode_time
  @@start_decode_time
  @@end_decode_time

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

  end

  get '/benchmark' do
    decode_time = @@end_decode_time.to_i - @@start_decode_time.to_i
    encode_time = @@end_encode_time.to_i - @@start_encode_time.to_i
    { decode_time: decode_time, encode_time: encode_time }.to_json
  end

  def time_in_microseconds
    Time.now.strftime '%6N'
  end

  run!
end
