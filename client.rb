module Client
  require 'httparty'

  def json_request(payload)
  end

  def msgpack_request(payload)
  end

  def protobuf_request(payload)
  end

  def get_benchmarks
    res = HTTParty.get(
      'http://localhost:4567/benchmark'
    )

    puts res
  end
end
