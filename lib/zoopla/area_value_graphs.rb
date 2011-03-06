class Zoopla
  
  class AreaValueGraphs < API
    
    # Defines the search area. All possible params are described at http://developer.zoopla.com/docs/
    # @param [Hash] Location hash
    # @return [AreaValueGraphs]
    def in(location)
      check_output_type location
      @request.merge! location
      reply = fetch_data(@request)
      fields = %w(area_values_url home_values_graph_url value_trend_graph_url value_ranges_graph_url average_values_graph_url)
      filtered = fields.inject({}) do |result, field|
        result[field] = reply[field]
        result
      end
      Hashie::Mash.new.update filtered
    end
    
    # Sets the size of the returned images to small
    # @return AreaValueGraphs
    def small
      @request[:size] = 'small'
      self
    end

    # Sets the size of the returned images to medium
    # @return AreaValueGraphs
    def medium
      @request[:size] = 'medium'
      self
    end

    # Sets the size of the returned images to large
    # @return AreaValueGraphs
    def large
      @request[:size] = 'large'
      self
    end

  private

    def api_call
      'area_value_graphs'
    end      

    def default_parameters
      {:output_type => 'outcode'}
    end

    def valid_output_types
      %w(outcode)
    end

  end
  
end