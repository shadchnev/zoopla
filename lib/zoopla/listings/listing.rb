module Zoopla
  
  module Listings
    
    # Common methods for Sales and Rentals classes
    module Listing
                  
      # Defines the search area. All possible params are described at http://developer.zoopla.com/docs/
      # @param [Hash] Location hash
      # @return [Sales, Rentals]
      def in(location)
        @request.merge! location
        self
      end
      
      # Sets the price range
      # @param [Range] price range (weekly in case of rentals), e.g. 200..300
      # @return [Sales, Rentals]
      def price(price_range)
        set_range_parameter(:price, price_range)
      end
      
      alias_method :for, :price
      
      # Sets the number of bedrooms range
      # @param [Range] bedrooms range, e.g. 2..3
      # @return [Sales, Rentals]
      def beds(beds_range)
        set_range_parameter(:beds, beds_range)
      end
      
      # Defines the size of the search area in miles. E.g. 2 miles around a location
      # @param [Fixum] radius in miles
      # @return [Sales, Rentals]
      def within(miles)
        ensure_valid_parameter('radius', miles, lambda {|p| (p.is_a? Float or p.is_a? Fixnum) and p >= 0})
        @request[:radius] = miles
        self
      end
      
      alias_method :radius, :within
      
      # The field by which the results should be ordered, either :price or :age of listing.
      # @param [Symbol, String] sorting field
      # @return [Sales, Rentals]
      def order_by(field)
        ensure_valid_parameter('sorting order', field, %w(price age))
        @request[:order_by] = field.to_s        
        self
      end
      
      # Sort order for the listings returned. Either :descending or :ascending
      # @param [Symbol, String] sorting order
      # @return [Sales, Rentals]
      def ordering(order)
        ensure_valid_parameter('ordering', order, %w(ascending descending))
        @request[:ordering] = order.to_s
        self
      end
      
      # Property type. Either :houses or :flats
      # @param [Symbol, String] property type
      # @return [Sales, Rentals]
      def property_type(type)
        ensure_valid_parameter('property type', type, %w(houses flats))
        @request[:property_type] = type.to_s
        self
      end
      
      # Search only for houses
      # @return [Sales, Rentals]
      def houses
        @request[:property_type] = 'houses'
        self
      end
      
      # Search only for flats
      # @return [Sales, Rentals]
      def flats
        @request[:property_type] = 'flats'
        self
      end
      
      # Keywords to search for within the listing description.
      # @param [Array, String] keywords
      # @return [Sales, Rentals]
      def keywords(keywords)
        ensure_valid_parameter('keywords', keywords, lambda {|k| k.is_a? Array or k.is_a? String})
        keywords = keywords.join(' ') if keywords.is_a? Array
        @request[:keywords] = keywords
        self
      end
      
      # Sets the minimum price. Weekly prices in case of rentals
      # @param [Fixnum] price
      # @return [Sales, Rentals]
      def minimum_price(price)
        set_limiting_value(:minimum, :price, price)
      end
      
      # Sets the maximum price. Weekly prices in case of rentals
      # @param [Fixnum] price
      # @return [Sales, Rentals]
      def maximum_price(price)
        set_limiting_value(:maximum, :price, price)
      end
      
      # Sets the minimum number of bedrooms
      # @param [Fixnum] number of bedrooms
      # @return [Sales, Rentals]
      def minimum_beds(beds)
        set_limiting_value(:minimum, :beds, beds)
      end
      
      # Sets the maximum number of bedrooms
      # @param [Fixnum] number of bedrooms
      # @return [Sales, Rentals]
      def maximum_beds(beds)
        set_limiting_value(:maximum, :beds, beds)
      end
      
      # Adds another listing id to the query. Calling this function multiple times will add multiple ids.
      # Please note that other provided arguments will still be taken into account when filtering listings
      # @param [Fixnum] listing id
      # @return [Sales, Rentals]
      def listing_id(listing_id)
        ensure_valid_parameter('listing id', listing_id, lambda {|k| k.is_a? Fixnum and k >= 0})
        @request[:listing_id] ||= []
        @request[:listing_id] << listing_id
        self        
      end
      
      # Iterates over the results. Possible fields are described at http://developer.zoopla.com/docs/read/Property_listings
      # @yield [Hashie::Mash] a listing with data, e.g. sales.each{|listing| puts listing.price }
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
      
      # Resets all parameters except the API key
      # @return [Rentals, Sales]
      def reset!
        @request = default_parameters
        self
      end      
      
      private
      
      def set_limiting_value(limit, attribute, value)
        ensure_valid_parameter("#{limit} #{attribute}", value, lambda {|p| p.is_a? Fixnum and p >= 0})
        @request["#{limit}_#{attribute}".to_sym] = value
        self        
      end
      
      def set_range_parameter(attribute, value)
        ensure_valid_parameter(attribute.to_s, value, lambda {|pr| pr.is_a? Fixnum or (pr.is_a?(Range) and pr.first <= pr.last)})
        value = value..value if value.is_a? Fixnum
        self.send("minimum_#{attribute}", value.first)
        self.send("maximum_#{attribute}", value.last)
        self        
      end
      
      def ensure_valid_parameter(parameter, value, valid_options)
        raise "#{parameter} not specified" unless value
        raise "Unknown #{parameter}: #{value}" if valid_options.is_a? Array and !valid_options.include?(value.to_s)
        raise "Invalid #{parameter}: #{value}" if valid_options.is_a? Proc  and !valid_options.call(value)
      end
      
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