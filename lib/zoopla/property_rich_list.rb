class Zoopla
  
  class PropertyRichList < API
    
    # Defines the search area. All possible params are described at http://developer.zoopla.com/docs/
    # @param [Hash] Location hash
    # @return [PropertyRichList]
    def in(location)
      check_output_type location
      # check_area_type location
      @request.merge! location
      reply = fetch_data(@request)
      result = Hashie::Mash.new
      result.richlist_url = result.url = reply.richlist_url
      result.highest = reply.highest
      result.lowest = reply.lowest
      result
    end
    
    private
        
    def api_call
      'richlist'
    end      

    def default_parameters
      {:output_type => 'outcode'}
    end

    def valid_output_types
      %w(outcode area town county country)
    end
    
    
  end
  
end