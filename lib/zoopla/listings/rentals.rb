module Zoopla
  
  module Listings
    
    class Rentals < API
      
      include Zoopla::Listings::Listing
      
      def initialize(*args)
        super(*args)
        @request = {:listing_status => 'rent'}
      end                         
      
      def include_rented
        @request[:include_rented] = '1'
        self
      end
      
      def furnished(value)
        ensure_valid_parameter('furnished', value, %w(furnished unfurnished part-furnished))
        @request[:furnished] = value.to_s
        self
      end
      
    end
    
  end
  
end