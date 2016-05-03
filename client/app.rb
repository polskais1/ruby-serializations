require_relative 'client'

include Client

payload = []
500.times { payload << {foo: "bar"} }
json_request({foo: "bar"})
