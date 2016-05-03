require 'sinatra/base'
require 'json'
class Server < Sinatra::Base
  # Benchmarks
  @@decode_time = 0
  @@encode_time = 0

  post '/json' do
    # Decode using JSON
    start_decode_time = time_in_microseconds
    decoded_request = JSON.parse(request.body.string)
    end_decode_time = time_in_microseconds
    @@decode_time = end_decode_time.to_i - start_decode_time.to_i

    # Encode using JSON
    start_encode_time = time_in_microseconds
    encoded_response = decoded_request.to_json
    end_encode_time = time_in_microseconds
    @@encode_time = end_encode_time.to_i - start_encode_time.to_i

    encoded_response
  end

  post '/msgpack' do

  end

  post '/protobuf' do

  end

  get '/benchmark' do
    content_type :json
    { decode_time: @@decode_time, encode_time: @@encode_time }.to_json
  end

  def time_in_microseconds
    Time.now.strftime '%6N'
  end

  run!
end
