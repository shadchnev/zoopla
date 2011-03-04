class Zoopla
  
  # Raised when Zoopla returns the HTTP status code 400
  class BadRequestError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 401
  class UnauthorizedRequestError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 403
  class ForbiddenError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 404
  class NotFoundError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 405
  class MethodNotAllowedError < StandardError; end
  
  # Raised when Zoopla returns the HTTP status code 500
  class InternalServerError < StandardError; end
  
  # Abstract class that understands how to talk to the API
  class API
    
    def initialize(api_key)
      @key = api_key
      reset!      
    end
    
    # Resets all parameters except the API key
    # @return [Rentals, Sales]
    def reset!
      @request = default_parameters
      @actual_location = nil
      self
    end
    
    # Holds standard output parameters for the call to the server, if any
    def actual_location
      return @actual_location if @actual_location
      fetch_data(@request)
    end     
    
    private
    
    def extract_actual_location(reply)
      @actual_location = Hashie::Mash.new
      %w(area_name street town postcode county country).each {|field|
        @actual_location[field] = reply[field]
      }
      @actual_location.bounding_box = parse_values_if_possible(reply.bounding_box)
    end
        
    def fetch_data(params)
      response_code, body = call(url(params))       
      if response_code == 200
        body = parse body
        extract_actual_location(body)
        return preprocess(body)
      end
      raise case response_code
      when 400 then BadRequestError.new "Not enough parameters to produce a valid response."
      when 401 then UnauthorizedRequestError.new "The API key could not be recognised and the request is not authorized."
      when 403 then ForbiddenError.new "The requested method is not available for the API key specified (the API key is invalid?)."
      when 404 then NotFoundError.new "A method was requested that is not available in the API version specified."
      when 405 then MethodNotAllowedError.new "The HTTP request that was made requested an API method that can not process the HTTP method used."
      when 500 then InternalServerError.new "Internal Server Error"
      else          StandardError.new "Unexpected HTTP error"
      end
    end
    
    def call(url)
      curl = Curl::Easy.new(url)
      curl.perform
      [curl.response_code, curl.body_str]
    end
        
    def url(params)
      params.inject("http://api.zoopla.co.uk/api/v1/#{api_call}.js?api_key=#{@key}") do |memo, item|
        memo += "&#{item.first}=#{CGI::escape item.last.to_s}"
      end
    end
    
    def tryParsingInteger(field, value)
      (value.to_i rescue 0) if %w(price listing_id num_bathrooms num_bedrooms num_floors num_recepts).include? field
    end
    
    def tryParsingFloat(field, value)
      (value.to_f rescue 0.0) if %w(longitude_min longitude_max latitude_min latitude_max).include? field
    end
    
    def tryParsingDate(field, value)
      (Date.parse(value) rescue value) if field == 'date'
    end
    
    def tryParsingHash(field, value)
      parse_values_if_possible(value) if value.is_a? Hash
    end
    
    def tryParsingArray(field, value)
       value.inject([]) {|memo, item| memo << parse_values_if_possible(item) } if value.is_a? Array
    end
    
    def parse_values_if_possible(reply)
      return reply unless reply.is_a? Hash
      reply.each_pair do |field, value|                
        reply[field] = tryParsingHash(field, value) || tryParsingArray(field, value) || tryParsingInteger(field, value) ||tryParsingFloat(field, value) || tryParsingDate(field, value) || value
      end
      reply
    end
    
    def parse(reply)
      Hashie::Mash.new.deep_update(parse_values_if_possible(JSON.parse reply))
    end
        
  end
  
end