class Zoopla
  
  class ZedIndex < API
    
    # Defines the search area. All possible params are described at http://developer.zoopla.com/docs/
    # @param [Hash] Location hash
    # @return [ZedIndex]
    def in(location)
      check_output_type location
      @request.merge! location
      reply = fetch_data(@request)
      fields = %w(area_url zed_index zed_index_3month zed_index_6month zed_index_1year zed_index_2year zed_index_3year zed_index_4year zed_index_5year)
      filtered = fields.inject({:latest => reply["zed_index"]}) do |result, field|
        result[field] = reply[field]
        result
      end
      Hashie::Mash.new.update filtered
    end
    
  private
    
    def api_call
      'zed_index'
    end      
    
    def default_parameters
      {:output_type => 'outcode'}
    end
    
    def valid_output_types
      %w(town outcode county country)
    end
        
  end
  
end