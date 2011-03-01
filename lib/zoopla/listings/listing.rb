module Zoopla
  
  module Listings
    
    module Listing
            
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
        fetched_so_far, number_of_results = 0, 0
        @request[:page_number] = 1
        begin
          number_of_results, listings = fetch_data(@request)
          fetched_so_far += listings.size
          @request[:page_number] += 1
          listings.each do |listing|
            yield listing
          end
        end while fetched_so_far < number_of_results 
      end
      
      private
      
      def preprocess(reply)
        number_of_results = reply["result_count"]
        listings = reply["listing"].inject([]) do |memo, listing|
          parse_values_if_possible(listing)
          memo << Hashie::Mash.new.update(listing)
        end
        [number_of_results, listings]        
      end
      
      def api_call
        'property_listings'
      end      
      
    end
    
  end
  
end