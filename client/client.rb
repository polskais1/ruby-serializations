module Client
  require 'httparty'
  require 'json'
  @@base_uri = 'http://localhost:4567'

  def json_request(payload)
    client_times = {}
    client_times[:start_time] = time_in_microseconds

    # Encode using JSON
    client_times[:start_encode_time] = time_in_microseconds
    serialized_payload = payload.to_json
    client_times[:end_encode_time] = time_in_microseconds

    res = HTTParty.post("#{@@base_uri}/json", {body: serialized_payload})

    # Decode using JSON
    client_times[:start_decode_time] = time_in_microseconds
    JSON.parse(res)
    client_times[:end_decode_time] = time_in_microseconds

    client_times[:end_time] = time_in_microseconds
    report_benchmarks(client_times)
  end

  def msgpack_request(payload)
  end

  def protobuf_request(payload)
  end

  def time_in_microseconds
    Time.now.strftime '%6N'
  end

  def report_benchmarks(client_times)
    total_encode_time = client_times[:end_decode_time].to_i - client_times[:start_decode_time].to_i
    total_decode_time = client_times[:end_encode_time].to_i - client_times[:start_encode_time].to_i
    total_time = client_times[:end_time].to_i - client_times[:start_time].to_i
    server_benchmarks = HTTParty.get("#{@@base_uri}/benchmark")

    puts "\nServer Benchmarks:"
    puts "Encode Time: #{server_benchmarks["encode_time"]}μs"
    puts "Decode Time: #{server_benchmarks["decode_time"]}μs"
    puts ""

    puts "Client Benchmarks:"
    puts "Encode Time: #{total_encode_time}"
    puts "Decode Time: #{total_decode_time}"
    puts ""

    puts "Total Time: #{total_time}"
  end
end
