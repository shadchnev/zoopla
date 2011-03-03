module Zoopla
  
  module Listings
    
    class Sales < API
      
      include Zoopla::Listings::Listing
      
      def initialize(*args)
        super(*args)
        @request = {:listing_status => 'sale'}
      end      
      
      # Whether to include property listings that are already sold in the results
      # return [Sales]
      def include_sold
        @request[:include_sold] = '1'
        self
      end                   
      
    end
    
  end
  
end