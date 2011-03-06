require 'curl'
require 'json'
require 'cgi'
require 'hashie'

require File.expand_path('../zoopla/version', __FILE__)
require File.expand_path('../zoopla/errors', __FILE__)
require File.expand_path('../zoopla/api', __FILE__)
require File.expand_path('../zoopla/listings', __FILE__)

class Zoopla
  
  def initialize(key)
    @api_key = key
  end
  
  # Delegates to the Rentals class
  # @return [Rentals]
  def rentals
    Rentals.new(@api_key)
  end
  
  # Delegates to the Sales class
  # @return [Sales]
  def sales
    Sales.new(@api_key)
  end
  
end