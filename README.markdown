# Zoopla API Wrapper

Use this gem to access real estate data using zoopla.co.uk API from ruby code.

  * property listings with addresses, prices, agent details etc
  * request parameters are chained: `sales.in{:area => "Camden, London"}.for(200000..250000).each{|listing| puts listing.price}`
  * transparent pagination: just pass a block to process listings
  * error handling
  * Zed-index
  * integers, dates and lat/lon parameters are parsed
  
  **This gem is pre-alpha, therefore it's missing important features and it not production ready. Also, the interface may change considerably in the future**

## Documentation
The gem documentation can be found on [Rdoc.info](http://rdoc.info/github/shadchnev/zoopla/master/frames)

The API documentation can be found on the [Zoopla Website](http://developer.zoopla.com/docs)

## Usage examples

### Property listings

First, initialise the object with the API key [you got from Zoopla](http://developer.zoopla.com/member/register/)

	$ sales = Zoopla.new('my_api_key').sales
	
Then chain the parameter calls and provide a block to process the listings

    $ sales.houses.in({:postcode => 'NW1 0DU'}).within(0.5).each{|l| puts "#{l.num_bedrooms}-bedrooms house for #{l.price} at #{l.displayable_address}"}

This will produce

		4-bedrooms house for 1525000 at Arlington Road, London
		2-bedrooms house for 1250000 at Rochester Mews, London
		4-bedrooms house for 999000 at Bonny Street, Camden Town, London
		...
		
To search for rentals, do a similar query:

    $ rentals = Zoopla.new('my_api_key').rentals
    $ rentals.flats.in({:postcode => 'NW1 0DU'}).within(0.5).for(300..350).each{|l| puts "#{l.num_bedrooms}-bedrooms flat for #{l.price}/week at #{l.displayable_address}"}

The input and output parameters for property listings are described in the [Zoopla documentation](http://developer.zoopla.com/docs/read/Property_listings)

### Disambiguation

If an ambiguous area is specified, a `Zoopla::DisambiguationError` will be raised

    begin
      zoopla.sales.in({:area => "Whitechapel"}).each{|listing| puts l.price}
    rescue Zoopla::DisambiguationError => e
      puts "Which of the following did you mean?"
      e.areas.each{|area| puts area} # areas is an Array of Strings
    end

The output will be

    Which of the following did you mean?
    Whitechapel, Devon
    Whitechapel, Lancashire
    Whitechapel, London

### Unknown locations

If an unknown location is specified, a `Zoopla::UnknownLocationError` will be raised. If the API can provide a spelling suggestion,
it will be available in `e.suggestion`

    begin
      zoopla.sales.in({:area => "Stok, Devon"}).each{|listing| puts l.price}
    rescue Zoopla::UnknownLocationError => e
      puts "Did you mean #{e.suggestion}" if e.suggestion
    end

The output will be

    Did you mean stoke, Devon
    
### Zed-index

To find out the [Zed-index](http://www.zoopla.co.uk/property/estimate/about/) of a place do

    $ index_set = zoopla.zed_index.in({:area => 'London', :output_type => "town"})
    $ puts index_set.latest # 427646
    $ puts index_set.zed_index # 427646
    $ puts index_set.zed_index_3month # 430923

The full list of possible fields can be found in the [documentation](http://developer.zoopla.com/docs/read/Zed_Index_API)

### Area value graphs

To get the list of graphs do

    $ graphs = zoopla.area_value_graphs.in({:postcode => "SW1A"})
    $ puts graphs.average_values_graph_url # http://www.zoopla.co.uk/dynimgs/graph/average_prices/SW1A?width=400&height=212
    
To specify the size, chain the methods

    $ graphs = zoopla.area_value_graphs.large.in({:postcode => "SW1A"})
    $ puts graphs.average_values_graph_url # http://www.zoopla.co.uk/dynimgs/graph/average_prices/SW1A?width=600&height=318

The full list of possible fields can be found in the [documentation](http://developer.zoopla.com/docs/read/Area_Value_Graphs)

### Property rich list

In line with all other methods

    $ list = zoopla.rich_list.in({:area => 'NW1', :output_type => :outcode, :area_type => :streets })
    $ list.url # "http://www.zoopla.co.uk/property/richlist/london/NW1/camden-town-regents-park-marylebone-north"
    $ list.lowest.first.name # "Wrotham Road, London NW1"
    
Valid combinations of `output_type`/`area_type` are described in the [documentation](http://developer.zoopla.com/docs/read/Property_Rich_List)    

## Contributing to zoopla
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Evgeny Shadchnev. See LICENSE.txt for further details.


