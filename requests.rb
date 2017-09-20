require 'net/http'
require 'json'

# Downloading the data through API requests
class Request
  attr_reader :uri

  def initialize(uri = 'codetest.kube.getswift.co')
    @uri = uri
  end

  def drones
    JSON.parse(Net::HTTP.get(uri, '/drones'))
  end

  def packages
    JSON.parse(Net::HTTP.get(uri, '/packages'))
  end

end