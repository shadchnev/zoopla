module Zoopla
  
  class API # abstract
    
    def initialize(api_key)
      @key = api_key
    end
    
    private
    
    def fetch_data(params)
      preprocess call(url(params))       
    end
    
    def call(url)
      curl = Curl::Easy.new(url)
      curl.perform
      JSON.parse curl.body_str
    end
        
    def url(params)
      params.inject("http://api.zoopla.co.uk/api/v1/#{api_call}.js?api_key=#{@key}") do |memo, item|
        memo += "&#{item.first}=#{CGI::escape item.last.to_s}"
      end
    end
    
    def tryParsingInteger(field, value)
      (value.to_i rescue 0) if %w(price listing_id num_bathrooms num_bedrooms num_floors num_recepts).include? field
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
      return reply if reply.is_a? String
      reply.each_pair do |field, value|                
        reply[field] = tryParsingHash(field, value) || tryParsingArray(field, value) || tryParsingInteger(field, value) || tryParsingDate(field, value) || value
      end
    end
        
  end
  
end