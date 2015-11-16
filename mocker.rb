require 'mirage/client'
require 'net/http'

class Mocker

 def initialize
   Mirage.start
   @mirage_client = Mirage::Client.new
 end

 def set_response(path,response,response_code=200,method='GET',delay=0)
   @mirage_client.put(path,response) do
     http_method method
     status response_code
     default true
     delay delay
   end
   @mirage_client.put('greeting', 'hello')
 end

 def service(uri,method,body='',headers={})

   http = Net::HTTP.new(uri.host, uri.port)
   if uri.host.include?('https')
     http.use_ssl = true
     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   end
   request = method.new(uri.request_uri)
   request.body = body
   # request.headers = {}
   http.request(request)
 end


end

@mock_response = Mocker.new


param_1='abc'
param_2='acbe'
make_time = {'productId'=>1, 'makeTime'=>2}
path = "/path/calling/api/#{param_1}/products/#{param_2}"
@mock_response.set_response(path,make_time.to_json)
response1 = @mock_response.service(URI.parse("http://localhost:7001/responses/greeting"),Net::HTTP::Get)
p response1.body
response2 = @mock_response.service(URI.parse( "http://localhost:7001/responses#{path}"),Net::HTTP::Get)
p response2.body

#if you want to see whats set in the mock disable the below two lines and check at http://localhost:7001
Mirage::Client.new.templates.delete_all
Mirage.stop :all
