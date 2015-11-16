require 'mirage/client'
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
 end


end


Mirage.start
@mock_response = Mocker.new

param_1='abc'
param_2='acbe'
make_time = {'productId'=>1, 'makeTime'=>2}
@mock_response.set_response("/path/calling/api/#{param_1}/products/#{param_2}",make_time.to_json)
