module Zoopla
  
  module Listings
    
    class Sales < API
      
      include Zoopla::Listings::Listing
      
      def initialize(*args)
        super(*args)
        @request = {:listing_status => 'sale'}
      end                         
      
    end
    
  end
  
end