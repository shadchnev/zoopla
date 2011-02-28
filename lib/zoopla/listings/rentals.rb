module Zoopla
  
  module Listings
    
    class Rentals < API            
      
      def initialize(*args)
        super(*args)
        @request = {}
      end
            
      def in(location)
        @request.merge! location
        self
      end
      
      def price(price_range)
        @request[:minimum_price] = price_range.first
        @request[:maximum_price] = price_range.last
        self
      end
      
      def within(miles)
        @request[:radius] = miles
        self
      end
      
      def each
        listings = fetch_data(@request)
        listings.each do |listing|
          yield listing
        end
      end
      
      private
      
      def preprocess(reply)
        reply["listing"].inject([]) do |memo, listing|
          parse_values_if_possible(listing)
          memo << Hashie::Mash.new.update(listing)
        end        
      end
      
      def api_call
        'property_listings'
      end
      
    end
    
  end
  
end