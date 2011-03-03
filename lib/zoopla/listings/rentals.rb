module Zoopla
  
  module Listings
    
    # Searches for rental listings
    class Rentals < API
      
      include Zoopla::Listings::Listing
      
      def initialize(*args)
        super(*args)
        reset!
      end                         
      
      # Include property listings that are already rented in the results
      # @return [Rentals]
      def include_rented
        @request[:include_rented] = '1'
        self
      end
      
      # Specify whether or not the apartment is "furnished", "unfurnished" or "part-furnished".
      # @return [Rentals]
      def furnished(value)
        ensure_valid_parameter('furnished', value, %w(furnished unfurnished part-furnished))
        @request[:furnished] = value.to_s
        self
      end
      
      private
      
      def default_parameters
        {:listing_status => 'rent'}
      end
                  
    end
    
  end
  
end