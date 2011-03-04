class Zoopla
  
  # Searches for sales listings
  class Sales < API
    
    include Zoopla::Listing
    
    def initialize(*args)
      super(*args)
      reset!
    end      
    
    # Whether to include property listings that are already sold in the results
    # @return [Sales]
    def include_sold
      @request[:include_sold] = '1'
      self
    end                   
    
    private
    
    def default_parameters
      {:listing_status => 'sale'}
    end
    
  end
  
  
end