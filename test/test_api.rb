require 'helper'

class TestAPI < Test::Unit::TestCase
  
  def setup
    @rentals = Zoopla.new('my_api_key').rentals
  end
  
  def test_actual_location
    @rentals.send(:extract_actual_location, @rentals.send(:parse, api_reply('postcode')))
    location = @rentals.actual_location
    assert_equal 'London', location.county
    assert_equal 'England', location.country
    assert_equal 'E1W 3TJ', location.postcode
    assert_equal 51.506390, location.bounding_box.latitude_min
    assert_equal 51.506390, location.bounding_box.latitude_max
    assert_equal -0.054738, location.bounding_box.longitude_max    
    assert_equal -0.054738, location.bounding_box.longitude_min    
  end
  
  def test_actual_location_fallback
    @rentals.expects(:fetch_data)
    @rentals.actual_location
  end
  
  def test_actual_location_fallback
    @rentals.send(:extract_actual_location, @rentals.send(:parse, api_reply('postcode')))
    @rentals.expects(:fetch_data).never
    @rentals.actual_location
  end
  
  def test_deep_parsing_the_reply
    reply = @rentals.send(:parse, api_reply('postcode'))
    listing = reply.listing.first
    assert_equal 11695072, listing.listing_id
    assert_equal 'rent', listing.listing_status    
    assert_equal 275, listing.price
    assert_equal 'Atkinson Mcleod', listing.agent_name
    assert_equal '135 Leman Street, Aldgate', listing.agent_address
    assert_equal 'http://static.zoopla.co.uk/zoopla_static_agent_logo_(26302).gif', listing.agent_logo
    assert_match(/^Charming one double bedroom apartment .+Our Ref: rpl\/iupload\/CTL070029$/m, listing.description)
    assert_equal 'http://www.zoopla.co.uk/to-rent/details/11695072', listing.details_url
    assert_equal 'Prospect Place, Wapping Wall, Wapping, London E1W', listing.displayable_address
    assert_equal 'http://content.zoopla.co.uk/18d7d607146d3f0ea8cd46c48b5984084613a8ce.jpg', listing.floor_plan.first
    assert_equal 'Picture No.05', listing.image_caption
    assert_equal 'http://images.zoopla.co.uk/f03d30a35c97bf20825af1db8f9e52e1c936dd42_354_255.jpg', listing.image_url
    assert_equal 51.50639, listing.latitude
    assert_equal(-0.054738, listing.longitude)
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
  
  def test_no_results_returned
    number_of_results, reply = @rentals.send(:preprocess, @rentals.send(:parse, api_reply('empty')))
    assert_equal 0, number_of_results
    assert_equal [], reply
  end
    
  def test_bad_request
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(400)
    assert_raises Zoopla::BadRequestError do
      @rentals.each{}
    end
  end
  
  def test_unauthorised_request
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(401)
    assert_raises Zoopla::UnauthorizedRequestError do
      @rentals.each{}
    end
  end
  
  def test_wrong_api_key
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(403)
    assert_raises Zoopla::ForbiddenError do
      @rentals.each{}
    end
  end
  
  def test_not_found
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(404)
    assert_raises Zoopla::NotFoundError do
      @rentals.each{}
    end
  end
  
  def test_method_not_allowed
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(405)
    assert_raises Zoopla::MethodNotAllowedError do
      @rentals.each{}
    end
  end
  
  def test_internal_server_error
    Curl::Easy.any_instance.stubs(:perform)
    Curl::Easy.any_instance.stubs(:response_code).returns(500)
    assert_raises Zoopla::InternalServerError do
      @rentals.each{}
    end
  end
  
end