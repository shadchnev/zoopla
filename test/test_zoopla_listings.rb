require 'helper'

class TestZooplaListings < Test::Unit::TestCase
  
  def setup
    @rentals = Zoopla::Listings::Rentals.new('abcdefghijklmnop123456')
  end
  
  def test_forming_the_request_by_chaining
    @rentals.in({:postcode => 'E1W 3TJ'}).within(2).price(200..400)
    expected = {:postcode => 'E1W 3TJ', :minimum_price => 200, :maximum_price => 400, :radius => 2}
    assert_equal expected, @rentals.instance_variable_get('@request')
  end
  
  def test_deep_parsing_the_reply
    reply = @rentals.send(:preprocess, JSON.parse(api_reply('postcode')))
    listing = reply.first
    assert_equal 11695072, listing.listing_id
    assert_equal 'rent', listing.listing_status    
    assert_equal 275, listing.price
    assert_equal 'Atkinson Mcleod', listing.agent_name
    assert_equal '135 Leman Street, Aldgate', listing.agent_address
    assert_equal 'http://static.zoopla.co.uk/zoopla_static_agent_logo_(26302).gif', listing.agent_logo
    assert_match /^Charming one double bedroom apartment .+Our Ref: rpl\/iupload\/CTL070029$/m, listing.description
    assert_equal 'http://www.zoopla.co.uk/to-rent/details/11695072', listing.details_url
    assert_equal 'Prospect Place, Wapping Wall, Wapping, London E1W', listing.displayable_address
    assert_equal 'http://content.zoopla.co.uk/18d7d607146d3f0ea8cd46c48b5984084613a8ce.jpg', listing.floor_plan.first
    assert_equal 'Picture No.05', listing.image_caption
    assert_equal 'http://images.zoopla.co.uk/f03d30a35c97bf20825af1db8f9e52e1c936dd42_354_255.jpg', listing.image_url
    assert_equal 51.50639, listing.latitude
    assert_equal -0.054738, listing.longitude
    assert_equal 0, listing.num_bathrooms
    assert_equal 1, listing.num_bedrooms
    assert_equal 0, listing.num_floors
    assert_equal 0, listing.num_recepts
    assert_equal 'E1W', listing.outcode
    assert_equal 'London', listing.post_town
    assert_equal 265, listing.price_change.first.price
    assert_equal Date.parse('2010-07-23 19:12:46'), listing.price_change.first.date
    assert_equal 275, listing.price_change.last.price
    assert_equal Date.parse('2011-01-06 19:00:45'), listing.price_change.last.date
    assert_equal 'Flat', listing.property_type
    assert_equal 'Wapping Wall Wapping London', listing.street_name
    assert_equal 'http://images.zoopla.co.uk/f03d30a35c97bf20825af1db8f9e52e1c936dd42_80_60.jpg', listing.thumbnail_url
  end
  
end
