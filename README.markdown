# Zoopla API Wrapper

Use this gem to access real estate data using zoopla.co.uk API from ruby code:

  * property listings with addresses, prices, agent details etc
  * more to come

## Documentation
The gem documentation can be found on [Rdoc.info](http://rdoc.info/github/shadchnev/zoopla/master/frames)

The API documentation can be found on the [Zoopla Website](http://developer.zoopla.com/docs)

## Usage examples

### Property listings

First, initialise the object with the API key [you got from Zoopla](http://developer.zoopla.com/member/register/)

	$ sales = Zoopla::Listings::Sales.new('my_api_key')
	
Then chain the parameter calls and provide a block to process the listings

    $ sales.houses.in({:postcode => 'NW1 0DU'}).within(0.5).each{|l| puts "#{l.num_bedrooms}-bedrooms house for #{l.price} at #{l.displayable_address}"}

This will produce

		4-bedrooms house for 1525000 at Arlington Road, London
		2-bedrooms house for 1250000 at Rochester Mews, London
		4-bedrooms house for 999000 at Bonny Street, Camden Town, London
		...
		
To search for rentals, do a similar query:

    $ rentals = Zoopla::Listings::Rentals.new('my_api_key')
    $ rentals.flats.in({:postcode => 'NW1 0DU'}).within(0.5).price(300..350).each{|l| puts "#{l.num_bedrooms}-bedrooms flat for #{l.price}/week at #{l.displayable_address}"}

The input and output parameters for property listings are described in the [Zoopla documentation](http://developer.zoopla.com/docs/read/Property_listings)


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

