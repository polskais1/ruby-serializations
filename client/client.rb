module Client
  require 'httparty'
  require 'json'
  require 'msgpack'
  require 'protobuf'
  
  @@base_uri = 'http://localhost:4567'
  # @@base_uri = 'https://ruby-serializations.herokuapp.com'

  # class for a message to be sent using Protocol Buffers
  class ProtoMessage < Protobuf::Message
    optional :string, :foo, 1
  end

  def json_request(payload)
    client_times = {}
    client_times[:start_time] = time_in_microseconds

    # Encode using JSON
    client_times[:start_encode_time] = time_in_microseconds
    serialized_payload = payload.to_json
    client_times[:end_encode_time] = time_in_microseconds

    response = HTTParty.post("#{@@base_uri}/json", {body: serialized_payload})

    # Decode using JSON
    client_times[:start_decode_time] = time_in_microseconds
    JSON.parse(response.body)
    client_times[:end_decode_time] = time_in_microseconds

    client_times[:end_time] = time_in_microseconds
    report_benchmarks(client_times)
  end

  def msgpack_request(payload)
    client_times = {}
    client_times[:start_time] = time_in_microseconds

    # Encode using MessagePack
    client_times[:start_encode_time] = time_in_microseconds
    serialized_payload = MessagePack.pack(payload)
    client_times[:end_encode_time] = time_in_microseconds

    response = HTTParty.post("#{@@base_uri}/msgpack", {body: serialized_payload, headers: { 'Content-Type' => 'octet-stream' }})
    # Decode using MessagePack
    client_times[:start_decode_time] = time_in_microseconds
    MessagePack.unpack(response.body)
    client_times[:end_decode_time] = time_in_microseconds

    client_times[:end_time] = time_in_microseconds
    report_benchmarks(client_times)
  end

  def protobuf_request(payload)
    client_times = {}
    client_times[:start_time] = time_in_microseconds

    # Encode using MessagePack
    client_times[:start_encode_time] = time_in_microseconds
    serialized_payload = ProtoMessage.new(payload).serialize
    client_times[:end_encode_time] = time_in_microseconds

    response = HTTParty.post("#{@@base_uri}/protobuf", {body: serialized_payload, headers: { 'Content-Type' => 'octet-stream' }})
    # Decode using MessagePack
    client_times[:start_decode_time] = time_in_microseconds
    ProtoMessage.decode(response.body)
    client_times[:end_decode_time] = time_in_microseconds

    client_times[:end_time] = time_in_microseconds
    report_benchmarks(client_times)
  end

  def time_in_microseconds
    Time.now.strftime '%s%6N'
  end

  def report_benchmarks(client_times)
    total_encode_time = client_times[:end_decode_time].to_i - client_times[:start_decode_time].to_i
    total_decode_time = client_times[:end_encode_time].to_i - client_times[:start_encode_time].to_i
    total_time = client_times[:end_time].to_i - client_times[:start_time].to_i
    server_benchmarks = HTTParty.get("#{@@base_uri}/benchmark")

    puts "\nServer Benchmarks:"
    puts "Encode Time: #{server_benchmarks['encode_time']}μs"
    puts "Decode Time: #{server_benchmarks['decode_time']}μs"

    puts "\nClient Benchmarks:"
    puts "Encode Time: #{total_encode_time}μs"
    puts "Decode Time: #{total_decode_time}μs"

    puts "\nTotal Time: #{total_time}μs"
  end
end
